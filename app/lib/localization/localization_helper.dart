import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../utils/constants/text_strings.dart';

class TLocalizationHelper extends GetxController {
  static TLocalizationHelper get instance => Get.find();
  final storage = GetStorage();
  final RxString currentLanguage = TTexts.english.obs;

  @override
  void onInit() {
    super.onInit();
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    await GetStorage.init();
    final lang = storage.read('Language') ?? TTexts.english;
    currentLanguage.value = lang;
    _updateLocale(lang);
  }

  Future<void> switchLanguage(String value) async {
    currentLanguage.value = value;
    await storage.write('Language', value);
    _updateLocale(value);
  }

  void _updateLocale(String value) {
    if (value == TTexts.english) {
      Get.updateLocale(const Locale('en', 'US'));
    } else if (value == TTexts.french) {
      Get.updateLocale(const Locale('fr', 'CA'));
    }else if (value == TTexts.german) {
      Get.updateLocale(const Locale('de', 'DE'));
    } else if (value == TTexts.portuguese) {
      Get.updateLocale(const Locale('pt', 'PT'));
    } else if (value == TTexts.brazilian) {
      Get.updateLocale(const Locale('pt', 'BR'));
    }else if (value == TTexts.vietnamese) {
      Get.updateLocale(const Locale('vi', 'VN'));
    } else if (value == TTexts.spanish) {
      Get.updateLocale(const Locale('es', 'ES'));
    } else if (value == TTexts.russian) {
      Get.updateLocale(const Locale('ru', 'RU'));
    }
  }
}

