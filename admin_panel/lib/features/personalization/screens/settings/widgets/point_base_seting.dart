import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/common/widgets/chips/animated_icon_switch.dart';
import 'package:t_utils/common/widgets/containers/t_container.dart';
import 'package:t_utils/common/widgets/texts/text_with_icon.dart';
import 'package:t_utils/utils/constants/sizes.dart';

import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/settings_controller.dart';

class PointBaseSettings extends StatelessWidget {
  final SettingsController controller;

  const PointBaseSettings({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TContainer(
      child: Obx(
        () => Column(
          children: [
            /// **Toggle Switch**
            Row(
              children: [

                Expanded(child: TTextWithIcon(text: TTexts.enablePointsSystem.tr, icon: Iconsax.discount_shape)),
                TIconToggleSwitch(
                  options: [true, false],
                  icons: [Icons.circle, Icons.circle_outlined],
                  current: controller.isPointBaseEnabled.value,
                  onChanged: controller.togglePointBaseSettings,
                ),
              ],
            ),
      
            /// **Input Fields**
            if (controller.isPointBaseEnabled.value) ...[
              SizedBox(height: TSizes().spaceBtwSections),
              // CustomTextField(
              //     controller: controller.purchasePointsController,
              //     label: 'Points per Dollar Spent',
              //     icon: Iconsax.shopping_bag),
              // CustomTextField(
              //     controller: controller.pointsToDollarController,
              //     label: 'Points to Dollar Conversion',
              //     icon: Iconsax.money_recive),
              // CustomTextField(
              //     controller: controller.ratingPointsController, label: 'Points per Rating', icon: Iconsax.star),
              // CustomTextField(
              //     controller: controller.reviewPointsController, label: 'Points per Review', icon: Iconsax.text_block),

              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.purchasePointsController,
                          keyboardType: TextInputType.number,
                          decoration:  InputDecoration(
                            labelText: TTexts.pointsPerDollarSpent.tr,
                            hintText: TTexts.pointsPerDollarSpentHint.tr,
                            helperText: TTexts.pointsPerDollarSpentHelper.tr,
                            helperMaxLines: 4,
                            prefixIcon: Icon(CupertinoIcons.money_rubl_circle),
                          ),
                        ),
                      ),
                      SizedBox(width: TSizes().spaceBtwItems),
                      Expanded(
                        child: TextFormField(
                          controller: controller.pointsToDollarController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: TTexts.pointsToDollarConversion.tr,
                            hintText: TTexts.pointsToDollarConversionHint.tr,
                            helperText: TTexts.pointsToDollarConversionHelper.tr,
                            helperMaxLines: 4,
                            prefixIcon: Icon(CupertinoIcons.money_dollar_circle),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: TSizes().spaceBtwItems),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.ratingPointsController,
                          keyboardType: TextInputType.number,
                          decoration:  InputDecoration(
                            labelText: TTexts.pointsPerRating.tr,
                            hintText: TTexts.pointsPerRatingHint.tr,
                            helperText: TTexts.pointsPerRatingHelper.tr,
                            helperMaxLines: 4,
                            prefixIcon: Icon(Iconsax.star),
                          ),
                        ),
                      ),
                      SizedBox(width: TSizes().spaceBtwItems),
                      Expanded(
                        child: TextFormField(
                          controller: controller.reviewPointsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: TTexts.pointsPerReview.tr,
                            hintText: TTexts.pointsPerReviewHint.tr,
                            helperText: TTexts.pointsPerReviewHelper.tr,
                            helperMaxLines: 4,
                            prefixIcon: Icon(Iconsax.text_block),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
