import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:cwt_ecommerce_admin_panel/features/personalization/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:t_utils/t_utils.dart';

import '../../../features/personalization/controllers/user_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/text_strings.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Variables
  final _auth = FirebaseAuth.instance;

  // Get Authenticated User Data
  User? get authUser => _auth.currentUser;

  // Get IsAuthenticated User
  bool get isAuthenticated => _auth.currentUser != null;

  // Called from main.dart on app launch
  @override
  void onReady() {
    _auth.setPersistence(Persistence.LOCAL);
  }

  // Function to determine the relevant screen and redirect accordingly.
  void screenRedirect() async {
    // If the user is logged in
    if (_auth.currentUser != null) {
      // Check if this is a Demo Account
      final userController = Get.put(UserController());
      if (userController.user.value.id.isEmpty)
        await userController.fetchUserDetails();

      if (userController.user.value.role == AppRole.demo) {
        Get.offAllNamed(TRoutes.dashboard);
      } else {
        // Check Admin Role in Firebase Auth
        // Refresh the token to get the latest custom claims
        await _auth.currentUser!.getIdToken(true);
        final idTokenResult = await _auth.currentUser!.getIdTokenResult();

        // Check if the 'admin' claim exists and is set to true
        if (idTokenResult.claims?['admin'] == true) {
          Get.offAllNamed(TRoutes.dashboard);
        } else {
          logout();
        }
      }
    } else {
      TFullScreenLoader.stopLoading();
      Get.offAllNamed(TRoutes.login);
    }
  }

  // Email & Password sign-in
  // LOGIN

  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      print('Email: $email, Password: $password');
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      handleAuthException(e);
      rethrow;
    }
  }

  // REGISTER
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      handleAuthException(e);
      rethrow;
    }
  }

  // REGISTER USER BY ADMIN
  Future<UserCredential> registerUserByAdmin(
      String email, String password) async {
    try {
      FirebaseApp app = await Firebase.initializeApp(
          name: 'RegisterUser', options: Firebase.app().options);
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);

      await app.delete();
      return userCredential;
    } catch (e) {
      handleAuthException(e);
      rethrow;
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      handleAuthException(e);
    }
  }

  // FORGET PASSWORD
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      handleAuthException(e);
    }
  }

  // RE AUTHENTICATE USER
  Future<void> reAuthenticateWithEmailAndPassword(
      String email, String password) async {
    try {
      // Create a credential
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);

      // ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } catch (e) {
      handleAuthException(e);
    }
  }

  /// --------------- CLOUD FUNCTIONS ------------------- ///

  Future<void> assignAdminRoleInAuthentication(String email) async {
    try {
      // After registration, call your Cloud Function to set custom claims (like admin)
      final setAdminRoleFunction = FirebaseFunctions.instance
          .httpsCallable('authentication-addAdminRole');
      final msg = await setAdminRoleFunction.call({'email': email});

      // Refresh the token to get the latest custom claims
      await _auth.currentUser!.getIdToken(true);
    } catch (e) {
      handleAuthException(e);
    }
  }

  Future<void> assignInvokerRole(String adminEmail) async {
    try {
      // Get the callable function
      final addInvokerRoleFunction =
          FirebaseFunctions.instance.httpsCallable('addInvokerRole');

      // Call the function with required parameters
      final result = await addInvokerRoleFunction.call({
        'adminEmail': adminEmail, // Pass admin email to assign invoker role
      });

      // Handle the response
      print(result
          .data['message']); // Prints: Invoker role added for <adminEmail>
    } catch (e) {
      handleAuthException(e);
    }
  }

  Future<String> createUser(String email, String password) async {
    try {
      final createUserFunction = FirebaseFunctions.instance
          .httpsCallable('authentication-registerUser');
      final result = await createUserFunction.call({
        'email': email,
        'password': password,
      });
      // Handling the returned data (uid and email)
      final data = result.data;
      String uid = data['user']['uid'];

      if (kDebugMode)
        print(
            'User registered successfully: UID = ${data['user']['uid']} , email: ${data['user']['email']}');
      return uid;
    } catch (e) {
      handleAuthException(e);
      return '';
    }
  }

  Future<void> deleteUser(String email) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('authentication-deleteUserByEmail');
      final result = await callable.call({'email': email});
      if (kDebugMode)
        print(result.data['message']); // User deleted successfully
    } catch (e) {
      handleAuthException(e);
    }
  }

  Future<void> deleteUserViaHttp(String uid) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('User is not logged in');
      return; // or handle the error appropriately
    }

    final idToken = await user.getIdToken();

    try {
      final response = await http.post(
        Uri.parse(
            'https://us-central1-your-project.cloudfunctions.net/deleteUser'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'uid': uid}),
      );

      if (response.statusCode == 200) {
        print('User deleted successfully');
        print(response.body); // Handle success response
      } else {
        print('Failed to delete user: ${response.body}');
      }
    } catch (e) {
      print('Error calling deleteUser function: $e');
    }
  }

  /// --------------- ./CLOUD FUNCTIONS END ------------------- ///

  // Logout User
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      UserController.instance.user.value = UserModel.empty();
      Get.offAllNamed(TRoutes.login);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print(e);
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      if (kDebugMode) print(e);
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      if (kDebugMode) print('Format Exception Caught');
      throw const TFormatException();
    } on PlatformException catch (e) {
      if (kDebugMode) print(e);
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print(e);
      throw 'Something went wrong. Please try again';
    }
  }

  // DELETE USER - Remove user Auth and Firestore Account.
  Future<void> deleteAccount() async {
    try {
      // await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } catch (e) {
      handleAuthException(e);
    }
  }

  void handleAuthException(e) {
    print("error is : ${e.toString()}");
    if (e is FirebaseAuthException) {
      throw TFirebaseAuthException(e.code).message;
    } else if (e is FirebaseException) {
      throw TFirebaseException(e.code).message;
    } else if (e is FormatException) {
      throw const TFormatException();
    } else if (e is PlatformException) {
      throw TPlatformException(e.code).message;
    } else {
      throw TTexts.somethingWentWrong.tr;
    }
  }
}
