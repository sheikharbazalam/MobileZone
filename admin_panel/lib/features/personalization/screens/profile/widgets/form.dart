import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/user_controller.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TTextWithIcon(text: TTexts.profileDetails.tr, icon: Iconsax.user),
        SizedBox(height: TSizes().spaceBtwSections),

        // First and Last Name
        Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.firstNameController,
                decoration:  InputDecoration(
                  hintText: TTexts.firstName.tr,
                  label: Text(TTexts.firstName.tr),
                  prefixIcon: Icon(Iconsax.user),
                ),
                validator: (value) => TValidator.validateEmptyText(TTexts.firstName.tr, value),
              ),

              SizedBox(height: TSizes().spaceBtwInputFields),

              TextFormField(
                controller: controller.lastNameController,
                decoration: InputDecoration(
                  hintText: TTexts.lastName.tr,
                  label: Text(TTexts.lastName.tr),
                  prefixIcon: Icon(Iconsax.user),
                ),
                validator: (value) => TValidator.validateEmptyText(TTexts.lastName.tr, value),
              ),

              SizedBox(height: TSizes().spaceBtwInputFields),

              // Email and Phone
              TextFormField(
                controller: controller.emailController,
                decoration: InputDecoration(
                    hintText: TTexts.email.tr, label: Text(TTexts.email.tr), prefixIcon: Icon(Iconsax.forward), enabled: false),
              ),

              SizedBox(height: TSizes().spaceBtwItems),

              // Last Name
              TextFormField(
                controller: controller.phoneController,
                decoration:  InputDecoration(
                  hintText: TTexts.phoneNumber.tr,
                  label: Text(TTexts.phoneNumber.tr),
                  prefixIcon: Icon(Iconsax.mobile),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: TSizes().spaceBtwSections),

        SizedBox(
          width: double.infinity,
          child: Obx(
            () => ElevatedButton(
              onPressed: () => controller.loading.value ? () {} : controller.updateUserInformation(),
              child: controller.loading.value
                  ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  :  Text(TTexts.updateProfile.tr),
            ),
          ),
        ),
      ],
    );
  }
}
