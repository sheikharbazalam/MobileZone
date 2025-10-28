import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/login_in_controller.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    // final dark = THelperFunctions.isDarkMode(context);
    final screenWidth = THelperFunctions.screenWidth();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace, vertical: TSizes.spaceBtwSections),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: TSizes.spaceBtwSections * 1.5),

              /// -- Lottie Animation (Header)
              BounceInDown(
                duration: const Duration(milliseconds: 800),
                child: Lottie.asset(
                  repeat: true,
                  width: screenWidth * 0.6,
                  'assets/images/animations/Animation - 1745236705111.json',
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Title
              FadeIn(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  TTexts.welcomeToStore.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),

              /// -- Subtitle
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: Text(
                  TTexts.shopSmartBetter.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16, color: Colors.grey.shade700),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Login Buttons Card
              FadeInUp(
                delay: const Duration(milliseconds: 900),
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    children: [
                      /// -- Email Login (White icon)
                      SizedBox(
                        width: screenWidth * 0.8,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.email_outlined, size: 28, color: Colors.white),
                          onPressed: () => Get.toNamed(TRoutes.logIn, arguments: 'EmailPassword'),
                          label: Text(TTexts.loginWithEmailPass.tr,),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      /// -- Phone Login (Larger icon)
                      SizedBox(
                        width: screenWidth * 0.8,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.phone_android, size: 28),
                          onPressed: () => Get.toNamed(TRoutes.phoneSignIn),
                          label: Text(TTexts.loginWithPhoneNo.tr),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: TColors.primary,
                            textStyle: const TextStyle(fontSize: 16),
                            side: const BorderSide(color: TColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      /// -- Google Sign-In Button (Larger icon)
                      SizedBox(
                        width: screenWidth * 0.8,
                        child: OutlinedButton.icon(
                          icon: Image.asset(
                            TImages.google,
                            width: 28,
                            height: 28,
                          ),
                          onPressed: () => controller.googleSignIn(),
                          label: Text(TTexts.signInWithGoogle.tr),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: TColors.primary),
                            foregroundColor: TColors.primary,
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Footer
              FadeInUp(
                delay: const Duration(milliseconds: 1100),
                child: RichText(
                  text: TextSpan(
                    text: TTexts.haveAnAccount.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
                    children: [
                      TextSpan(
                        text: TTexts.signUp.tr,
                        recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(TRoutes.signup),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: TColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
