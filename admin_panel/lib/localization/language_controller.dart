import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/text_strings.dart';
import 'localization_helper.dart';

class LanguageController extends GetxController {
  static LanguageController get instance => Get.find();

  final TLocalizationHelper localization = Get.find();

  void showLanguageSelector() {
    Get.dialog(
      _LanguageSelectorDialog(),
      barrierDismissible: true,
    );
  }

  void selectLanguage(String value) {
    Get.back(); // Close the dialog
    switch (value) {
      case 'en':
        localization.switchLanguage(TTexts.english);
        break;
      case 'fr':
        localization.switchLanguage(TTexts.french);
        break;
      case 'de':
        localization.switchLanguage(TTexts.dutch);
        break;
      case 'pt_PT':
        localization.switchLanguage(TTexts.portuguese);
        break;
      case 'pt_BR':
        localization.switchLanguage(TTexts.brazilian);
        break;
      case 'vi':
        localization.switchLanguage(TTexts.vietnamese);
        break;
      case 'es':
        localization.switchLanguage(TTexts.spanish);
        break;
      case 'ru':
        localization.switchLanguage(TTexts.russian);
        break;
    }
  }
}

class _LanguageSelectorDialog extends StatelessWidget {
  final LanguageController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Language'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(TTexts.english),
            onTap: () => controller.selectLanguage('en'),
          ),
          ListTile(
            title: Text(TTexts.french),
            onTap: () => controller.selectLanguage('fr'),
          ),

          ListTile(
            title: Text(TTexts.dutch),
            onTap: () => controller.selectLanguage('de'),
          ),
          ListTile(
            title: Text(TTexts.portuguese),
            onTap: () => controller.selectLanguage('pt_PT'),
          ),
          ListTile(
            title: Text(TTexts.brazilian),
            onTap: () => controller.selectLanguage('pt_BR'),
          ),
          ListTile(
            title: Text(TTexts.vietnamese),
            onTap: () => controller.selectLanguage('vi'),
          ),
          ListTile(
            title: Text(TTexts.spanish),
            onTap: () => controller.selectLanguage('es'),
          ),
          ListTile(
            title: Text(TTexts.russian),
            onTap: () => controller.selectLanguage('ru'),
          ),
        ],
      ),
    );
  }
}
