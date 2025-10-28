import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tstore_ecommerce_app/features/personalization/controllers/language_controller.dart';

import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import 'language_card.dart';

class AllLanguageWidget extends StatelessWidget {
  const AllLanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LanguageController.instance;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: Column(
        spacing: TSizes.spaceBtwItems,
        children: [
          /// -- Section Heading
          const TSectionHeading(
            title: "All Languages",
            showActionButton: false,
          ),

          /// -- Languages List
          Obx(() => Column(
            spacing: TSizes.spaceBtwItems,
            children: controller.filteredLanguages.map((language) =>
                LanguageCard(
                  languageName: language['name']!,
                  languageCode: language['code']!,
                  flagAsset: language['flag']!,
                ),
            ).toList(),
          )),
        ],
      ),
    );
  }
}
