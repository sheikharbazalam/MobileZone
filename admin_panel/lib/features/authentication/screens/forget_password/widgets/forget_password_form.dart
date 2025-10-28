import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';


import '../../../../../../utils/constants/text_strings.dart';

import '../../../controllers/forget_password_controller.dart';

class ForgetPasswordForm extends StatelessWidget {
  const ForgetPasswordForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Headings
        IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left)),
        SizedBox(height: TSizes().spaceBtwItems),
        Text(TTexts.forgetPasswordTitle.tr, style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: TSizes().spaceBtwItems),
        Text(TTexts.forgetPasswordSubTitle.tr, style: Theme.of(context).textTheme.labelMedium),
        SizedBox(height: TSizes().spaceBtwSections * 2),

        /// Text field
        Form(
          key: controller.forgetPasswordFormKey,
          child: TextFormField(
            controller: controller.email,
            validator: TValidator.validateEmail,
            decoration: const InputDecoration(labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct_right)),
          ),
        ),
        SizedBox(height: TSizes().spaceBtwSections),

        /// Submit Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: () => controller.sendPasswordResetEmail(), child: Text(TTexts.submit.tr)),
        ),
        SizedBox(height: TSizes().spaceBtwSections * 2),
      ],
    );
  }
}
