import 'package:get/get.dart';

import '../features/personalization/controllers/language_controller.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    /// -- Core
    Get.lazyPut(() => LanguageController());
  }
}