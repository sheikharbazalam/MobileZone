import 'dart:convert';

import 'package:get/get.dart';

class DatabaseTranslationModel {
  String language;
  String translation;

  DatabaseTranslationModel({required this.language, required this.translation});

  toJson() {
    return {
      'language': language,
      'translation': translation,
    };
  }

  factory DatabaseTranslationModel.translate(String encodedJson) {
    if (encodedJson.isEmpty) return DatabaseTranslationModel(language: "", translation: "");

    List<dynamic> list = json.decode(encodedJson);
    Map<String, dynamic> data = {};

    for (var element in list) {
      if (element['language'].toString().toLowerCase() == Get.locale!.languageCode.toLowerCase()) {
        data = element;
        break;
      }
    }
    return DatabaseTranslationModel(
      language: data['language'] ?? "",
      translation: data['translation'] ?? data['name'] ?? "",
    );
  }
}
