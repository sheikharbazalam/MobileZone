import 'package:cwt_ecommerce_admin_panel/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/general_bindings.dart';
import 'common/widgets/page_not_found/page_not_found.dart';
import 'localization/languages.dart';
import 'routes/app_routes.dart';
import 'routes/route_observer.dart';
import 'utils/constants/text_strings.dart';

import 'package:t_utils/t_utils.dart';
import 'utils/theme/theme.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Get.deviceLocale,
      title: TTexts.appName,
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      translations: Languages(),
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      initialBinding: GeneralBindings(),
      navigatorObservers: [RouteObservers()],
      scrollBehavior: MyCustomScrollBehavior(),
      initialRoute: TRoutes.dashboard,
      getPages: TAppRoute.pages,
      localizationsDelegates: const [
        quill.FlutterQuillLocalizations.delegate,
      ],
      unknownRoute: GetPage(
        name: '/page-not-found',
        page: () => TPageNotFound(
          isFullPage: true,
          title: TTexts.pageNotFoundTitle.tr,
          subTitle:
          TTexts.pageNotFoundSubTitle.tr,
        ),
      ),
      home: Scaffold(
        backgroundColor: TColors().primary,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
    );
  }
}
