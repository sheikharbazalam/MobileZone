import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants/image_strings.dart';

import 'package:t_utils/t_utils.dart';

import '../../../utils/constants/text_strings.dart';

/// Controller for handling forget password functionality
class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  /// Text editing controller for email field
  final email = TextEditingController();

  /// Form key for forget password form
  final forgetPasswordFormKey = GlobalKey<FormState>();

  /// Sends a password reset email
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(TTexts.processingRequest.tr, TImages.ridingIllustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      TLoaders.successSnackBar(title: TTexts.emailSent.tr, message: TTexts.emailLinkSentToResetPassword.tr);
      Get.offNamed(TRoutes.resetPassword, arguments: email.text.trim());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: e.toString());
    }
  }

  /// Resends a password reset email
  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(TTexts.processingRequest.tr, TImages.ridingIllustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.trim());

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show success message
      TLoaders.successSnackBar(title: TTexts.emailSent.tr, message: TTexts.emailLinkSentToResetPassword.tr);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: e.toString());
    }
  }
}
