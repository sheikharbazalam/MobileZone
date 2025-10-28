import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../controllers/coupon/edit_coupon_controller.dart';
import '../../../models/coupon_model.dart';
import 'layouts/desktop.dart';
import 'layouts/mobile.dart';
import 'layouts/tablet.dart';

class EditCouponScreen extends StatelessWidget {
  const EditCouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditCouponController());
    controller.coupon.value = Get.arguments ?? CouponModel.empty();
    controller.couponId.value = Get.parameters['id'] ?? '';

    // Initialize the controller data outside the build method
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.init());

    return const TSiteTemplate(desktop: DesktopScreen(), tablet: TabletScreen(), mobile: MobileScreen());
  }
}
