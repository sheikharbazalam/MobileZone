import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes.dart';

import '../common/widgets/layouts/sidebars/sidebar_controller.dart';
import '../data/repositories/authentication/authentication_repository.dart';

class TRouteMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final sidebar = Get.put(SidebarController());
    sidebar.activeItem(route);
    return AuthenticationRepository.instance.isAuthenticated ? null : const RouteSettings(name: TRoutes.login);
   }
}
