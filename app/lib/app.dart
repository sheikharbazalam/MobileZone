import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/general_bindings.dart';
import 'features/personalization/controllers/language_controller.dart';
import 'localization/languages.dart';
import 'routes/app_routes.dart';
import 'utils/constants/colors.dart';
import 'utils/constants/text_strings.dart';
import 'utils/theme/theme.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final langController = Get.put(LanguageController(), permanent: true);

    return Obx(
      () => GetMaterialApp(
        title: TTexts.appName,
        locale: langController.selectedLocale.value,
        translations: Languages(),
        fallbackLocale: const Locale('en', 'US'),
        theme: TAppTheme.lightTheme,
        themeMode: ThemeMode.system,
        darkTheme: TAppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        initialBinding: GeneralBindings(),
        localizationsDelegates: const [
          quill.FlutterQuillLocalizations.delegate,
        ],
        getPages: AppRoutes.pages,

        /// Loader screen while deciding which screen to show
        home: const Scaffold(
          backgroundColor: TColors.primary,
          body: Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      ),
    );
  }
}
