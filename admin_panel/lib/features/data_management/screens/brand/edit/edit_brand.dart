import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../controllers/brand/edit_brand_controller.dart';
import '../../../models/brand_model.dart';
import 'layouts/desktop.dart';
import 'layouts/mobile.dart';
import 'layouts/tablet.dart';

class EditBrandScreen extends StatelessWidget {
  const EditBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditBrandController());
    controller.brand.value = Get.arguments ?? BrandModel.empty();
    controller.brandId.value = Get.parameters['id'] ?? '';

    // Initialize the controller data outside the build method
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.init());

    return const TSiteTemplate(desktop: DesktopScreen(), tablet: TabletScreen(), mobile: MobileScreen());
  }
}
