import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../controllers/customer_detail_controller.dart';
import '../../../models/user_model.dart';
import 'responsive_screens/desktop.dart';
import 'responsive_screens/mobile.dart';
import 'responsive_screens/tablet.dart';

class CustomerDetailScreen extends StatelessWidget {
  const CustomerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerDetailController());
    controller.customer.value = Get.arguments ?? UserModel.empty();
    controller.customerId.value = Get.parameters['id'] ?? '';

    // Initialize the controller data outside the build method
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.init());

    return const TSiteTemplate(desktop: DesktopScreen(), tablet: TabletScreen(), mobile: MobileScreen());
  }
}
