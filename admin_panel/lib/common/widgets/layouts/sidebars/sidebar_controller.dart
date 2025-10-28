import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../routes/routes.dart';

/// Controller for managing the sidebar state and functionality
class SidebarController extends GetxController {
  /// Instance of SidebarController
  static SidebarController instance = Get.find();

  /// Observable variable to track the active menu item
  final activeItem = TRoutes.dashboard.obs;

  /// Observable variable to track the menu item being hovered over
  final hoverItem = ''.obs;

  /// Change the active menu item
  void changeActiveItem(String route) => activeItem.value = route;

  /// Change the menu item being hovered over
  void changeHoverItem(String route) {
    if (!isActive(route)) hoverItem.value = route;
  }

  /// Check if a route is the active menu item
  bool isActive(String route) => activeItem.value == route;

  /// Check if a route is being hovered over
  bool isHovering(String route) => hoverItem.value == route;

  /// Handler for menu item tap
  Future<void> menuOnTap(String route) async {
    try {
      if (!isActive(route)) {
        // Update Selected Menu Item
        changeActiveItem(route);

        // If Menu Drawer opened in Mobile, Close it.
        if (TDeviceUtils.isMobileScreen(Get.context!)) Get.back();

        // Navigate to other screen OR Logout
        if (route == 'logout') {
          await AuthenticationRepository.instance.logout();
        } else {
          Get.toNamed(route);
        }
      }
    } catch (e) {
      // Show error snack bar if an error occurs
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}