import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tstore_ecommerce_app/features/personalization/controllers/language_controller.dart';

import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import 'language_card.dart';

class DefaultSectionWidget extends StatelessWidget {
  const DefaultSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LanguageController.instance;
    final defaultLanguage = controller.allLanguages.firstWhere(
          (lang) => lang['code'] == 'fr', // French is default
      orElse: () => controller.allLanguages.first,
    );

    return Obx(() {
      // Only show default language if it matches search or search is empty
      if (controller.searchQuery.value.isEmpty ||
          defaultLanguage['name']!.toLowerCase()
              .contains(controller.searchQuery.value.toLowerCase())) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
          child: Column(
            spacing: TSizes.spaceBtwItems,
            children: [
              /// -- Default Heading
              TSectionHeading(
                title: "Default",
                showActionButton: false,
              ),
              LanguageCard(
                languageName: "French",
                languageCode: "fr",
                flagAsset: TImages.french,
              ),
            ],
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
