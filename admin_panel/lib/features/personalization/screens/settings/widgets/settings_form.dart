import 'package:cwt_ecommerce_admin_panel/features/personalization/screens/settings/widgets/point_base_seting.dart';
import 'package:cwt_ecommerce_admin_panel/features/personalization/screens/settings/widgets/tax_shipping_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/settings_controller.dart';

/// A form widget for managing application settings including
/// tax, shipping, and point-based rewards.
class SettingsForm extends StatelessWidget {
  const SettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.find<SettingsController>();

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// App Name
          TContainer(
            padding: EdgeInsets.all(TSizes().defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// System Settings Header
                TTextWithIcon(text: TTexts.systemSettings.tr, icon: Iconsax.settings),
                SizedBox(height: TSizes().spaceBtwSections),

                /// Logo Upload Section
                _buildLogoUploader(controller),
                SizedBox(height: TSizes().spaceBtwSections),
                //
                // const TTextWithIcon(text: 'App Information', icon: Iconsax.mobile),
                // SizedBox(height: TSizes().spaceBtwSections),

                TextFormField(
                  controller: controller.appNameController,
                  decoration: InputDecoration(
                    labelText: TTexts.appNameLabel.tr,
                    hintText: TTexts.appNameHint.tr,
                    prefixIcon: Icon(Iconsax.user),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: TSizes().spaceBtwInputFields),

          /// Tax & Shipping Settings Section
          TaxShippingSettings(controller: controller),
          SizedBox(height: TSizes().spaceBtwSections),

          /// Point Base Settings Section
          PointBaseSettings(controller: controller),
          SizedBox(height: TSizes().spaceBtwSections),

          /// **Update Button**
          _buildUpdateButton(controller),
        ],
      ),
    );
  }

  /// **Logo Upload Widget**
  Widget _buildLogoUploader(SettingsController controller) {
    return Obx(
      () => Center(
        child: TImageUploader(
          width: 200,
          height: 200,
          circular: false,
          icon: Iconsax.camera,
          loading: controller.loading.value,
          onIconButtonPressed: controller.updateAppLogo,
          imageType: controller.selectedImageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
          image:
              controller.selectedImageURL.value.isNotEmpty ? controller.selectedImageURL.value : TImages.defaultImage,
        ),
      ),
    );
  }

  /// **Update Button**
  Widget _buildUpdateButton(SettingsController controller) {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => ElevatedButton(
          onPressed: () => controller.loading.value ? () {} : controller.updateSettingInformation(),
          child: controller.loading.value
              ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
              : Text(TTexts.updateProfileButton.tr),
        ),
      ),
    );
  }
}