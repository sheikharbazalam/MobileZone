import 'package:cwt_ecommerce_admin_panel/features/admin_managment/controller/create_admin_controller.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

class CreateAdminForm extends StatelessWidget {
  CreateAdminForm({super.key});

  final controller = CreateAdminController.instance;

  @override
  Widget build(BuildContext context) {
    return TFormContainer(
      isLoading: controller.isLoading.value,
      padding:  EdgeInsets.symmetric(vertical: TSizes().defaultSpace * 2, horizontal: TSizes().defaultSpace),
      child: Form(
        key: controller.createCustomerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text("Add Admin Details", style: Theme.of(context).textTheme.headlineLarge),
                  Text("Please enter personal details of the admin for registration", style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            ),

            SizedBox(height: TSizes().spaceBtwSections),

            // Todo: Add Profile Picture

            /// Image
            // Center(
            //   child: Obx(
            //     () => TImageUploader(
            //       right: 0,
            //       bottom: 0,
            //       left: null,
            //       width: 200,
            //       height: 200,
            //       circular: true,
            //       loading: controller.isLoading.value,
            //       imageType: controller.profileImageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
            //       image: controller.profileImageURL.value.isNotEmpty
            //           ? controller.profileImageURL.value
            //           : TImages.truckWithUser,
            //       onIconButtonPressed: () => controller.selectImageFromMedia(DocumentType.profileImageURL),
            //     ),
            //   ),
            // ),
            SizedBox(height: TSizes().spaceBtwSections),

            /// First & Last Name
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.firstName,
                    validator: (value) => TValidator.validateEmptyText('First name', value),
                    expands: false,
                    decoration: InputDecoration(
                        labelText: 'First name', prefixIcon: Icon(Iconsax.user, color: TColors().primary)),
                  ),
                ),
                 SizedBox(width: TSizes().spaceBtwInputFields),
                Expanded(
                  child: TextFormField(
                    controller: controller.lastName,
                    validator: (value) => TValidator.validateEmptyText('Last name', value),
                    expands: false,
                    decoration: InputDecoration(
                        labelText: 'Last name', prefixIcon: Icon(Iconsax.user, color: TColors().primary)),
                  ),
                ),
              ],
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            /// Role Selection
            Obx(() {
              return DropdownButtonFormField<AppRole>(
                validator: (value) => value == null ? 'Please select a role' : null,
                value: controller.selectedRole.value,
                items: AppRole.values
                    .where((role) => role == AppRole.superAdmin || role == AppRole.admin)
                    .map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role.name), // Or use custom labels if needed
                ))
                    .toList(),
                onChanged: (value) {
                  controller.selectedRole.value = value!;
                },
                decoration: InputDecoration(
                  labelText: 'Select Role',
                  prefixIcon: Icon(Iconsax.category, color: TColors().primary),
                ),
              );
            }),
            SizedBox(height: TSizes().spaceBtwInputFields),

            /// Email
            TextFormField(
              controller: controller.email,
              validator: (value) => TValidator.validateEmail(value),
              decoration: InputDecoration(
                  labelText: 'Email', prefixIcon: Icon(Iconsax.message, color: TColors().primary)),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),


            /// Password
            Obx(
                  () => TextFormField(
                obscureText: controller.hidePassword.value,
                controller: controller.password,
                validator: (value) => TValidator.validateEmptyText('Password', value),
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Iconsax.password_check ,color: TColors().primary ),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                  ),
                ),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwSections),



            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? () {} : () => controller.createUser(),
                  child: controller.isLoading.value ? const Text('Processing...') : const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
