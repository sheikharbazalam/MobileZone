import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/forget_password_controller.dart';
import '../login/login.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      /// Appbar to go back OR close all screens and Goto LoginScreen()
      appBar: TAppBar(
        actions: [
          IconButton(onPressed: () => Get.offAll(const LoginScreen()), icon: const Icon(CupertinoIcons.clear)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes().defaultSpace),
          child: Column(
            children: [
              /// Image with 60% of screen width
              Image(
                image: const AssetImage(TImages.deliveredEmailIllustration),
                width: THelperFunctions.screenWidth() * 0.6,
              ),
              SizedBox(height: TSizes().spaceBtwSections),

              /// Title & SubTitle
              Text(TTexts.changeYourPasswordTitle.tr, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              SizedBox(height: TSizes().spaceBtwItems),
              Text('mrtaimoorsikander@gmail.com', textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelLarge),
              SizedBox(height: TSizes().spaceBtwItems),
              Text(
                TTexts.changeYourPasswordSubTitle.tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: TSizes().spaceBtwSections),

              /// Buttons
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () => Get.offAll(() => const LoginScreen()), child: Text(TTexts.done.tr))),
              SizedBox(height: TSizes().spaceBtwItems),
              SizedBox(
                  width: double.infinity,
                  child: TextButton(onPressed: () => controller.resendPasswordResetEmail(email), child: Text(TTexts.resendEmail.tr))),
            ],
          ),
        ),
      ),
    );
  }
}
