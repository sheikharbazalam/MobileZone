import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../data/repositories/setting/setting_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/text_strings.dart';
import '../../personalization/models/setting_model.dart';
import '../../personalization/models/user_model.dart';
import '../../role_management/controllers/role/role_controller.dart';

/// Controller for handling login functionality
class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// Whether the password should be hidden
  final hidePassword = true.obs;

  /// Whether the user has selected "Remember Me"
  final rememberMe = false.obs;

  /// Local storage instance for remembering email and password
  final localStorage = GetStorage();

  /// Text editing controller for the email field
  final email = TextEditingController();

  /// Text editing controller for the password field
  final password = TextEditingController();

  /// Form key for the login form
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // Retrieve stored email and password if "Remember Me" is selected
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  /// Handles email and password sign-in process
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          TTexts.loggingYouIn.tr, TImages.ridingIllustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      print('Email: ${email.text.trim()}, Password: ${password.text.trim()}');

      // Login user using Email & Password Authentication
      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Note: Fetching of user data on login and Settings info has been moved to OnInit()

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TNotificationOverlay.error(context: Get.context!, title: e.toString());
    }
  }

  /// Handles registration of admin user
  Future<void> registerAdmin() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          TTexts.registeringAdminAccount.tr, TImages.ridingIllustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Register user using Email & Password Authentication
      await AuthenticationRepository.instance.registerWithEmailAndPassword(
          email.text.trim(), password.text.trim());

      // Assign Admin Role in Authentication
      await AuthenticationRepository.instance
          .assignAdminRoleInAuthentication(email.text.trim());

      // Create admin record in the Firestore
      final userRepository = Get.put(UserRepository());
      final user = UserModel(
        id: AuthenticationRepository.instance.authUser!.uid,
        firstName: 'Super',
        lastName: 'Admin',
        email: email.text.trim(),
        role: AppRole.superAdmin,
        isEmailVerified: true,
        isProfileActive: true,
        orderCount: 0,
        points: 0,
        verificationStatus: VerificationStatus.approved,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await userRepository.addNewItem(user);

      // Create settings record in the Firestore
      final settingsRepository = Get.put(SettingsRepository());
      await settingsRepository.registerSettings(SettingsModel(
        appLogo: '',
        appName: 'MobiJunction',
        taxRate: 0,
        shippingCost: 0,
        freeShippingThreshold: 0,
        pointsPerPurchase: 0,
        pointsPerRating: 0,
        pointsPerReview: 0,
        pointsToDollarConversion: 0,
      ));

      await RoleController.instance.addDefaultRolesAndPermissions();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TNotificationOverlay.error(context: Get.context!, title: e.toString());
    }
  }
}
