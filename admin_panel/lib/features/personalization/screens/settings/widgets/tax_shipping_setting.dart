import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/common/widgets/chips/animated_icon_switch.dart';
import 'package:t_utils/common/widgets/containers/t_container.dart';
import 'package:t_utils/common/widgets/texts/text_with_icon.dart';
import 'package:t_utils/utils/constants/sizes.dart';

import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/settings_controller.dart';

class TaxShippingSettings extends StatelessWidget {
  final SettingsController controller;

  const TaxShippingSettings({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TContainer(
      child: Obx(
        () => Column(
          children: [
            /// **Toggle Switch**
            Row(
              children: [
                Expanded(child: TTextWithIcon(text: TTexts.enableTaxShipping.tr, icon: Iconsax.tag)),
                TIconToggleSwitch(
                  options: [true, false],
                  icons: [Icons.circle, Icons.circle_outlined],
                  current: controller.isTaxShippingEnabled.value,
                  onChanged: controller.toggleTaxShippingSettings,
                ),
              ],
            ),

            /// **Input Fields**
            if (controller.isTaxShippingEnabled.value) ...[
              SizedBox(height: TSizes().spaceBtwSections),
              // CustomTextField(controller: controller.taxController, label: 'Tax Rate (%)', icon: Iconsax.tag),
              // CustomTextField(
              //     controller: controller.shippingController, label: 'Shipping Cost (\$)', icon: Iconsax.ship),
              // CustomTextField(
              //     controller: controller.freeShippingThresholdController,
              //     label: 'Free Shipping Threshold (\$)',
              //     icon: Iconsax.ship),
              TextFormField(
                controller: controller.taxController,
                decoration: InputDecoration(
                  labelText: TTexts.taxRate.tr,
                  hintText: TTexts.taxRateHint.tr,
                  helperMaxLines: 3,
                  helperText: TTexts.taxRateHelper.tr,
                  prefixIcon: Icon(Iconsax.tag),
                ),
              ),
              SizedBox(height: TSizes().spaceBtwItems),
              TextFormField(
                controller: controller.shippingController,
                decoration: InputDecoration(
                  hintText: TTexts.shippingCost.tr,
                  labelText: TTexts.shippingCostLabel.tr,
                  helperText: TTexts.shippingCostHelper.tr,
                  helperMaxLines: 3,
                  prefixIcon: Icon(Iconsax.ship),
                ),
              ),
              SizedBox(height: TSizes().spaceBtwItems),
              TextFormField(
                controller: controller.freeShippingThresholdController,
                decoration: InputDecoration(
                  hintText: TTexts.freeShippingAfter.tr,
                  labelText: TTexts.freeShippingThreshold.tr,
                  helperText: TTexts.freeShippingThresholdHelper.tr,
                  helperMaxLines: 3,
                  prefixIcon: Icon(Iconsax.ship),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
