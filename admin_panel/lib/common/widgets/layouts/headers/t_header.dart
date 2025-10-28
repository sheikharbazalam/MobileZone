import 'package:cwt_ecommerce_admin_panel/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../features/personalization/controllers/user_controller.dart';
import '../../../../localization/language_controller.dart';
class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    final languageController = Get.put(LanguageController());

    return Obx(
          () => TAdminHeader(
        scaffoldKey: scaffoldKey,
        showNotificationIcon: false,
        loading: controller.loading.value,
        profileEmail: controller.user.value.email,
        profileName: controller.user.value.fullName,
        profileImage: controller.user.value.profilePicture,
        profileOnTap: () => Get.toNamed(TRoutes.profile),
        onOrderPressed: () => Get.toNamed(TRoutes.orders),
        onSettingsPressed: () => Get.toNamed(TRoutes.settings),
        actions: [
          TIcon(
            onPressed: languageController.showLanguageSelector,
            icon: Icons.language,
            backgroundColor: TColors().primary.withValues(alpha: 0.1),
            color: TColors().primary,
          ),
          SizedBox(width: TSizes().spaceBtwItems),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
}
// class THeader extends StatelessWidget implements PreferredSizeWidget {
//   const THeader({
//     super.key,
//     required this.scaffoldKey,
//   });
//
//   /// GlobalKey to access the Scaffold state for mobile drawer management.
//   final GlobalKey<ScaffoldState> scaffoldKey;
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = UserController.instance;
//
//     final localization = TLocalizationHelper.instance;
//
//     return Obx(
//       () => TAdminHeader(
//         scaffoldKey: scaffoldKey,
//         showNotificationIcon: false,
//         loading: controller.loading.value,
//         profileEmail: controller.user.value.email,
//         profileName: controller.user.value.fullName,
//         profileImage: controller.user.value.profilePicture,
//         profileOnTap: () => Get.toNamed(TRoutes.profile),
//         onOrderPressed: () => Get.toNamed(TRoutes.orders),
//         onSettingsPressed: () => Get.toNamed(TRoutes.settings),
//         actions: [
//           PopupMenuButton<String>(
//             icon: TIcon(
//               icon: Icons.language,
//               backgroundColor: TColors().primary.withValues(alpha: 0.1),
//               color: TColors().primary,
//             ),
//             onSelected: (value) async {
//               // WidgetsBinding.instance.addPostFrameCallback((_) {
//               //   debugPrint('Current routes:');
//               //   Navigator.of(Get.context!).widget.route?.debugPrint();
//               // });
//
//               if (value == 'en') {
//                 TLocalizationHelper.switchLanguage(TTexts.english);
//               } else if (value == 'fr') {
//                 TLocalizationHelper.switchLanguage(TTexts.french);
//               }
//             },
//             itemBuilder: (context) => [
//               PopupMenuItem(value: 'en', child: Text(TTexts.english)),
//               PopupMenuItem(value: 'fr', child: Text(TTexts.french)),
//             ],
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
// }
