import 'package:get/get.dart';

import '../../../../data/repositories/coupon/coupons_repository.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/popups/loaders.dart';
import '../models/coupon_model.dart';
import 'product/checkout_controller.dart';

class CouponController extends GetxController {
  static CouponController get instance => Get.find();
  final Rx<CouponModel> coupon = CouponModel.empty().obs;
  RxBool isCouponToggled = false.obs;

  // Inject the repository
  final CouponRepository couponRepository = Get.put(CouponRepository());

  Future<List<CouponModel>> fetchAllItems() {
    return couponRepository.fetchAllItems();
  }

  Future<void> applyCoupon(CouponModel selectedCoupon) async {
    if (selectedCoupon.usageCount == selectedCoupon.usageLimit) {
      TLoaders.warningSnackBar(title: TTexts.ohSnap.tr, message: TTexts.noMoreCoupon.tr);
    } else {
      coupon.value = selectedCoupon;
      CheckoutController.instance.isCouponToggled.value= true;
      Get.back();
      TLoaders.successSnackBar(title: TTexts.great.tr, message: TTexts.couponApplied.tr);
    }
  }

  Future<void> updateUsageCount(CouponModel coupon) async {
    int count = coupon.usageCount;
    count++;
    await couponRepository.updateSingleField(coupon.id, {
      'usageCount': count,
    });
  }
}
