import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tstore_ecommerce_app/features/personalization/controllers/language_controller.dart';

import '../../../../../common/styles/spacing_styles.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class LanguageHeader extends StatelessWidget {
  const LanguageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = LanguageController.instance;

    return Container(
      width: double.infinity,
      padding: TSpacingStyle.topNotchStylePadding,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)),
          color: TColors.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -- Display back button
          TRoundedContainer(
            padding: EdgeInsets.zero,
            backgroundColor: TColors.lightContainer.withValues(alpha: 0.2),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: TColors.iconPrimaryDark),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          /// -- Title
          Text("Languages",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: TColors.white)),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// -- Search Box
          TextField(
            controller: TextEditingController(
                text: controller.searchQuery.value),
            onChanged: controller.filterLanguages,
            decoration: InputDecoration(
              hintText: TTexts.searchLanguage.tr,
              hintStyle: Theme.of(context).textTheme.titleSmall,
              border: InputBorder.none,
              filled: true,
              fillColor: dark
                  ? TColors.darkContainer
                  : TColors.lightContainer,
            ),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
