import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/notification/create_notification_controller.dart';

class CreateNotificationForm extends StatelessWidget {
  const CreateNotificationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateNotificationController());
    return TFormContainer(
      isLoading: controller.isLoading.value,
      padding: EdgeInsets.all(TSizes().defaultSpace),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Heading
            SizedBox(height: TSizes().sm),
            TTextWithIcon(text: TTexts.createNotificationHeading.tr, icon: Iconsax.notification),
            SizedBox(height: TSizes().spaceBtwSections),

            // Text Field
            TextFormField(
              controller: controller.title,
              validator: (value) => TValidator.validateEmptyText(TTexts.notificationTitle.tr, value),
              decoration: InputDecoration(labelText:TTexts.notificationTitle.tr, prefixIcon: Icon(Iconsax.subtitle)),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            TextFormField(
              controller: controller.description,
              validator: (value) => TValidator.validateEmptyText(TTexts.notificationDescription.tr, value),
              decoration: InputDecoration(labelText: TTexts.notificationDescription.tr, prefixIcon: Icon(Iconsax.note)),
            ),

            SizedBox(height: TSizes().spaceBtwInputFields * 2),

            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () => controller.createNotification(), child: Text(TTexts.create.tr)),
                      ),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
