import 'package:cwt_ecommerce_admin_panel/features/personalization/controllers/settings_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/role_management/controllers/role/role_controller.dart';
import 'package:get/get.dart';
import 'package:t_utils/utils/helpers/network_manager.dart';
import '../features/personalization/controllers/user_controller.dart';
import '../localization/localization_helper.dart';


class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    /// -- Core
    Get.lazyPut(() => NetworkManager(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
    Get.lazyPut(() => RoleController(), fenix: true);
    Get.put(TLocalizationHelper());
    // Get.lazyPut(() => NotificationService(), fenix: true);
  }
}
