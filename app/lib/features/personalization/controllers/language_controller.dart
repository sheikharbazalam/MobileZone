import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tstore_ecommerce_app/utils/constants/image_strings.dart';

class LanguageController extends GetxController {
  static LanguageController get instance => Get.find();
  final box = GetStorage();
  var selectedLocale = const Locale('en', 'US').obs;
  var searchQuery = ''.obs;
  var filteredLanguages = <Map<String, String>>[].obs;

  // List of all available languages
  final allLanguages = [
    {'name': 'French', 'code': 'fr', 'flag': TImages.french},
    {'name': 'English', 'code': 'en', 'flag': TImages.usa},
    {'name': 'Brazilian', 'code': 'pt_BR', 'flag': TImages.brazil},
    {'name': 'German', 'code': 'de', 'flag': TImages.germany},
    {'name': 'Portuguese', 'code': 'pt', 'flag': TImages.portugal},
    {'name': 'Russian', 'code': 'ru', 'flag': TImages.russia},
    {'name': 'Spanish', 'code': 'es', 'flag': TImages.spain},
    {'name': 'Vietnamese', 'code': 'vi', 'flag': TImages.vietnam},
  ];

  @override
  void onInit() {
    super.onInit();
    // Load saved language preference from GetStorage
    String? savedLang = box.read<String>('language');
    if (savedLang != null) {
      selectedLocale.value = Locale(savedLang);
      Get.updateLocale(selectedLocale.value);
    }
    filteredLanguages.value = List.from(allLanguages);
  }

  // Method to Change Language
  void changeLanguage(String languageCode) {
    selectedLocale.value = Locale(languageCode);
    Get.updateLocale(selectedLocale.value);
    box.write('language', languageCode);
  }

  // Method to filter languages based on search query
  void filterLanguages(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredLanguages.value = List.from(allLanguages);
    } else {
      filteredLanguages.value = allLanguages
          .where((lang) =>
          lang['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}