import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../common/widgets/images/t_circular_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/language_controller.dart';

class LanguageCard extends StatelessWidget {
  final String languageName;
  final String languageCode;
  final String flagAsset;

  const LanguageCard({super.key,
    required this.languageName,
    required this.languageCode,
    required this.flagAsset,
  });

  @override
  Widget build(BuildContext context) {
    final controller = LanguageController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Obx(() => GestureDetector(
      onTap: () => controller.changeLanguage(languageCode),
      child: TRoundedContainer(
        backgroundColor: dark ? TColors.darkContainer : TColors.lightContainer,
        radius: TSizes.cardRadiusSm * 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TRoundedContainer(
                  radius: TSizes.cardRadiusSm * 2,
                  padding: const EdgeInsets.all(TSizes.sm),
                  backgroundColor: dark ? TColors.lightContainer.withValues(alpha: 0.1) : TColors.white ,
                  child: TCircularImage(image: flagAsset,padding: 0,height: 40,width: 40,)

                ),

                /// -- Country Flag


                const SizedBox(width: TSizes.spaceBtwItems),

                /// -- Country Name
                Text(
                  languageName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),

            /// -- Radio Button
            Radio(
              value: languageCode,
              groupValue: controller.selectedLocale.value.languageCode,
              onChanged: (value) => controller.changeLanguage(languageCode),
              activeColor: TColors.primary,
            ),
          ],
        ),
      ),
    ));
  }
}
