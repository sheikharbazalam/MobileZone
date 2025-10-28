import 'package:get/get.dart';

import '../features/shop/controllers/coupon_controller.dart';

class CouponBinding extends Bindings {
  @override
  void dependencies() {
    /// -- Core
    Get.lazyPut(() => CouponController());
  }
}