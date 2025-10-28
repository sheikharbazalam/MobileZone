import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../controllers/category/edit_category_controller.dart';
import '../../../models/category_model.dart';
import 'layouts/desktop.dart';
import 'layouts/mobile.dart';
import 'layouts/tablet.dart';

class EditCategoryScreen extends StatelessWidget {
  const EditCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditCategoryController());
    controller.category.value = Get.arguments ?? CategoryModel.empty();
    controller.categoryId.value = Get.parameters['id'] ?? '';

    // Initialize the controller data outside the build method
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.init());

    return const TSiteTemplate(desktop: DesktopScreen(), tablet: TabletScreen(), mobile: MobileScreen());
  }
}
