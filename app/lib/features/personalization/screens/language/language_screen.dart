import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'widget/all_language_widget.dart';
import 'widget/default_section_widget.dart';
import 'widget/language_header.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SingleChildScrollView(
        child: Column(
          spacing: TSizes.spaceBtwSections,
          children: [
            LanguageHeader(),
        
            /// -- Default Language
            DefaultSectionWidget(),
        
            /// -- All languages
            AllLanguageWidget(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton.icon(
          onPressed: () => Get.back(),
          label: Text(TTexts.saveSettings.tr),
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          iconAlignment: IconAlignment.end,
        ),
      ),
    );
  }
}
