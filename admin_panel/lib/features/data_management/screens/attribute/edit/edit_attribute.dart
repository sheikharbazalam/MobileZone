import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../controllers/attribute/edit_attribute_controller.dart';
import '../../../models/attribute_model.dart';
import 'layouts/desktop.dart';
import 'layouts/mobile.dart';
import 'layouts/tablet.dart';

class EditAttributeScreen extends StatelessWidget {
  const EditAttributeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditAttributeController());
    controller.attribute.value = Get.arguments ?? AttributeModel.empty();
    controller.attributeId.value = Get.parameters['id'] ?? '';

    // Initialize the controller data outside the build method
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.init());

    return const TSiteTemplate(desktop: DesktopScreen(), tablet: TabletScreen(), mobile: MobileScreen());
  }
}
