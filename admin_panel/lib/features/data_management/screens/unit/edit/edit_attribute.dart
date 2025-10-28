import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../controllers/unit/edit_unit_controller.dart';
import '../../../models/unit_model.dart';
import 'layouts/desktop.dart';
import 'layouts/mobile.dart';
import 'layouts/tablet.dart';

class EditUnitScreen extends StatelessWidget {
  const EditUnitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditUnitController());
    controller.unit.value = Get.arguments ?? UnitModel.empty();
    controller.unitId.value = Get.parameters['id'] ?? '';

    // Initialize the controller data outside the build method
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.init());

    return const TSiteTemplate(desktop: DesktopScreen(), tablet: TabletScreen(), mobile: MobileScreen());
  }
}
