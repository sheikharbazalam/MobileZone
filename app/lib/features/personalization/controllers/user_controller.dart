import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:t_utils/utils/constants/enums.dart';

import '../../../common/widgets/loaders/circular_loader.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../data/services/notifications/notification_service.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../models/user_model.dart';
import '../screens/profile/re_authenticate_user_login_form.dart';
import 'settings_controller.dart';

/// Controller to manage user-related functionality.
class UserController extends GetxController {
  static UserController get instance => Get.find();

  Rx<UserModel> user = UserModel.empty().obs;
  final imageUploading = false.obs;
  final profileLoading = false.obs;
  final profileImageUrl = ''.obs;
  final hidePassword = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  final settingController = Get.put(SettingsController());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  /// init user data when Home Screen appears
  @override
  void onInit() {
    fetchUserRecord();
    super.onInit();
  }

  /// Fetch user record
  Future<void> fetchUserRecord({bool fetchLatestRecord = false}) async {
    try {
      if (fetchLatestRecord) {
        profileLoading.value = true;
        final user = await userRepository.fetchUserDetails();
        this.user(user);
      } else {
        // Check if user is logged in and has a valid ID
        if (user.value.id != AuthenticationRepository.instance.getUserID) {
          user.value = UserModel.empty();
        }

        // Fetch user data from the repository
        if (user.value.id.isEmpty) {
          profileLoading.value = true;
          final user = await userRepository.fetchUserDetails();
          this.user(user);
        }
      }
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Warning', message: 'Unable to fetch your information. Try again.');
    } finally {
      profileLoading.value = false;
    }
  }

  /// Save user Record from any Registration provider
  Future<void> saveUserRecord({UserModel? user, UserCredential? userCredentials}) async {
    try {
      // First UPDATE Rx User and then check if user data is already stored. If not store new data
      await fetchUserRecord();

      // If no record already stored.
      if (this.user.value.id.isEmpty) {
        if (userCredentials != null) {
          // Convert Name to First and Last Name
          final nameParts = UserModel.nameParts(userCredentials.user!.displayName ?? '');
          final customUsername = UserModel.generateUsername(userCredentials.user!.displayName ?? '');

          final token = await TNotificationService.getToken();

          // Map data
          final newUser = UserModel(
            id: userCredentials.user!.uid,
            firstName: nameParts[0],
            lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : "",
            userName: customUsername,
            email: userCredentials.user!.email ?? '',
            profilePicture: userCredentials.user!.photoURL ?? '',
            deviceToken: token,
            isEmailVerified: true,
            isProfileActive: true,
            updatedAt: DateTime.now(),
            createdAt: DateTime.now(),
            role: AppRole.user,
            verificationStatus: VerificationStatus.approved,
            addresses: [],
            orderCount: 0,
            phoneNumber: '',
          );

          // Save user data
          await userRepository.saveUserRecord(newUser);

          // Assign new user to the RxUser so that we can use it through out the app.
          this.user(newUser);
        } else if (user != null) {
          // Save Model when user registers using Email and Password
          await userRepository.saveUserRecord(user);

          // Assign new user to the RxUser so that we can use it through out the app.
          this.user(user);
        }
      }
    } catch (e) {
      TLoaders.warningSnackBar(
        title: 'Data not saved',
        message: 'Something went wrong while saving your information. You can re-save your data in your Profile.',
      );
    }
  }

  /// Update user record after login (e.g., to update token)
  Future<void> updateUserRecordWithToken(String newToken) async {
    try {
      // Ensure we have fetched the user record before updating
      await fetchUserRecord();
      // Create a map to store the fields we want to update (e.g., token)
      Map<String, dynamic> updatedFields = {'deviceToken': newToken};

      // Call the repository to update the specific fields
      await userRepository.updateSingleField(updatedFields);

      // Update the local RxUser object with the new token
      user.value.deviceToken = newToken;
      user.refresh();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to update user record: $e');
    }
  }

  /// Update user record after login (e.g., to update Pin)
  Future<void> updateUserRecordWithPin(String pin) async {
    try {
      // Ensure we have fetched the user record before updating
      await fetchUserRecord();
      // Create a map to store the fields we want to update (e.g., token)
      Map<String, dynamic> updatedFields = {'pin': pin};

      // Call the repository to update the specific fields
      await userRepository.updateSingleField(updatedFields);

      // Update the local RxUser object with the new token
      user.value.pin = pin;
      user.refresh();
    } catch (e) {
      TLoaders.errorSnackBar(title: TTexts.error.tr, message: '${TTexts.failedToUpdateUserRecord.tr}: $e');
    }
  }

  /// - Increments `orderCount` by 1.
  /// - Adds `pointsPerPurchase * total` to `points`.
  /// - Subtracts `usedPoints` from `points`.
  /// - Updates the local `user` object in memory after the write.
  Future<void> updateUserAfterOrder({required double total, required bool isUsingPoints}) async {
    try {
      // 1️⃣ Refresh user from Firestore to get the latest values.
      await fetchUserRecord(fetchLatestRecord: true);

      // 2️⃣ Compute the new values based on existing user state:
      final currentOrderCount = user.value.orderCount;
      int currentPoints = user.value.points;
      currentPoints = isUsingPoints ? 0 : currentPoints;

      // Earned points = total * pointsPerPurchase (convert to int)
      final earnedPoints = (total * settingController.settings.value.pointsPerPurchase).toInt();

      // New points balance = (currentPoints + earned)
      final newPoints = currentPoints + earnedPoints;

      // New order count = current + 1
      final newOrderCount = currentOrderCount + 1;

      // 3️⃣ Prepare a single map of all fields to update:
      final updatedFields = <String, dynamic>{'orderCount': newOrderCount, 'points': newPoints};

      // 4️⃣ Perform exactly one write operation:
      await userRepository.updateSingleField(updatedFields);

      // 5️⃣ Update local Rx user object so UI stays in sync:
      user.update((u) {
        if (u != null) {
          u.orderCount = newOrderCount;
          u.points = newPoints;
        }
      });
      user.refresh();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: '${TTexts.failToUpdateUserRecord.tr} $e');
    }
  }

  /// Update user points per purchase
  Future<void> updateUserPointsPerReview() async {
    try {
      // Ensure we have fetched the user record before updating
      await fetchUserRecord();

      int points = user.value.points;
      points = points + settingController.settings.value.pointsPerReview.round();
      Map<String, dynamic> updatedFields = {'points': points};

      // Call the repository to update the specific fields
      await userRepository.updateSingleField(updatedFields);

      // Update the local RxUser object with the order Count
      user.value.points = points;
      user.refresh();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: '${TTexts.failToUpdateUserRecord.tr} $e');
    }
  }

  /// Update user points per purchase
  Future<void> updateUserPointsPerRating() async {
    try {
      // Ensure we have fetched the user record before updating
      await fetchUserRecord();

      int points = user.value.points;
      points = points + settingController.settings.value.pointsPerRating.round();
      Map<String, dynamic> updatedFields = {'points': points};

      // Call the repository to update the specific fields
      await userRepository.updateSingleField(updatedFields);

      // Update the local RxUser object with the order Count
      user.value.points = points;
      user.refresh();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: '${TTexts.failToUpdateUserRecord.tr} $e');
    }
  }

  /// Upload Profile Picture
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70, maxHeight: 512, maxWidth: 512);
      if (image != null) {
        imageUploading.value = true;
        final uploadedImage = await userRepository.uploadImage('Users/Images/Profile/', image);
        profileImageUrl.value = uploadedImage;
        Map<String, dynamic> newImage = {'ProfilePicture': uploadedImage};
        await userRepository.updateSingleField(newImage);
        user.value.profilePicture = uploadedImage;
        user.refresh();

        imageUploading.value = false;
        TLoaders.successSnackBar(title: TTexts.congratulation.tr, message: TTexts.profileImageUpdated.tr);
      }
    } catch (e) {
      imageUploading.value = false;
      TLoaders.errorSnackBar(title:  TTexts.ohSnap.tr, message: '${TTexts.somethingWentWrong.tr} $e');
    }
  }

  /// Delete Account Warning
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: TTexts.deleteAccount.tr,
      middleText:
      TTexts.deleteAccountSubText.tr,
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
        child: Padding(padding: EdgeInsets.symmetric(horizontal: TSizes.lg), child: Text(TTexts.delete.tr)),
      ),
      cancel: OutlinedButton(child: Text(TTexts.cancel.tr), onPressed: () => Navigator.of(Get.overlayContext!).pop()),
    );
  }

  /// Delete User Account
  void deleteUserAccount() async {
    try {
      TFullScreenLoader.openLoadingDialog(TTexts.processing.tr, TImages.docerAnimation);

      /// First re-authenticate user
      final auth = AuthenticationRepository.instance;
      final provider = auth.firebaseUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        // Re Verify Auth Email
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          TFullScreenLoader.stopLoading();
          Get.offAllNamed(TRoutes.logIn);
        } else if (provider == 'facebook.com') {
          TFullScreenLoader.stopLoading();
          Get.offAllNamed(TRoutes.logIn);
        } else if (provider == 'password') {
          TFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: TTexts.ohSnap.tr, message: e.toString());
    }
  }

  /// -- RE-AUTHENTICATE before deleting
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      TFullScreenLoader.openLoadingDialog(TTexts.processing.tr, TImages.docerAnimation);

      //Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticateWithEmailAndPassword(verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      TFullScreenLoader.stopLoading();
      Get.offAllNamed(TRoutes.logIn);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: TTexts.ohSnap.tr, message: e.toString());
    }
  }

  /// Logout Loader Function
  logout() {
    try {
      Get.defaultDialog(
        contentPadding: const EdgeInsets.all(TSizes.md),
        title: TTexts.logout.tr,
        middleText: TTexts.sureLogout.tr,
        confirm: ElevatedButton(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: TSizes.lg), child: Text(TTexts.confirm.tr)),
          onPressed: () async {
            onClose();

            /// On Confirmation show any loader until user Logged Out.
            Get.defaultDialog(title: '', barrierDismissible: false, backgroundColor: Colors.transparent, content: const TCircularLoader());
            await AuthenticationRepository.instance.logout();
          },
        ),
        cancel: OutlinedButton(child: Text(TTexts.cancel.tr), onPressed: () => Navigator.of(Get.overlayContext!).pop()),
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: e.toString());
    }
  }
}
