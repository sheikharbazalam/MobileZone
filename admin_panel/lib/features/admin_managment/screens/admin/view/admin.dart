import 'package:cwt_ecommerce_admin_panel/features/admin_managment/controller/admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import 'responsive_screens/desktop.dart';
import 'responsive_screens/mobile.dart';
import 'responsive_screens/tablet.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdminController());
    return const TSiteTemplate(desktop: AdminDesktopScreen(), tablet: AdminTabletScreen(), mobile: AdminMobileScreen());
  }
}
