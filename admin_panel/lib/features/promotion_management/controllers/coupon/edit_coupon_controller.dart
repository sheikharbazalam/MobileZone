import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/coupon/coupons_repository.dart';
import '../../../../routes/routes.dart';

import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../models/coupon_model.dart';
import 'coupon_controller.dart';

import 'package:t_utils/t_utils.dart';

class EditCouponController extends GetxController {
  static EditCouponController get instance => Get.find();

  // Inject the repository
  final CouponRepository couponRepository = Get.put(CouponRepository());
  final couponController = Get.put(CouponController());

  final isLoading = false.obs;
  final isActive = true.obs;

  final formKey = GlobalKey<FormState>();
  final code = TextEditingController();
  final description = TextEditingController();
  final discountValue = TextEditingController();
  final usageLimit = TextEditingController();
  final discountType = DiscountType.percentage.obs;
  final startDateTextField = TextEditingController();
  final endDateTextField = TextEditingController();
  final startDate = DateTime.now().obs;
  final endDate = DateTime.now().obs;
  final coupon = CouponModel.empty().obs;
  final couponId = ''.obs;

  /// Init Data
  Future<void> init() async {
    try {
      isLoading.value = true;

      // Fetch record if argument was null
      if (coupon.value.id.isEmpty) {
        if (couponId.isEmpty) Get.offNamed(TRoutes.coupons);

        coupon.value = await couponRepository.getSingleItem(couponId.value);
      }

      code.text = coupon.value.code;
      description.text = coupon.value.description;
      discountValue.text = coupon.value.discountValue.toString();
      usageLimit.text = coupon.value.usageLimit.toString();
      discountType.value = coupon.value.discountType;
      startDate.value = coupon.value.startDate ?? DateTime.now();
      endDate.value = coupon.value.endDate ?? DateTime.now();
      startDateTextField.text = coupon.value.startDate != null ? TFormatter.formatDate(coupon.value.startDate) : '';
      endDateTextField.text = coupon.value.endDate != null ? TFormatter.formatDate(coupon.value.endDate) : '';
      isActive.value = coupon.value.isActive;
    } catch (e) {
      if (kDebugMode) printError(info: e.toString());
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: TTexts.unableToFetchCouponDetails.tr);
    } finally {
      isLoading.value = false;
    }
  }

  /// Register new Coupon
  Future<void> updateCoupon(CouponModel coupon) async {
    try {
      // Start Loading
      isLoading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      if (endDate.value.isBefore(startDate.value)) throw TTexts.chooseStartEndDatesProperly.tr;

      // Map Data
      coupon.code = code.text.trim();
      coupon.description = code.text.trim();
      coupon.discountValue = double.tryParse(discountValue.text.trim()) ?? 0;
      coupon.usageLimit = int.tryParse(usageLimit.text.trim()) ?? 0;
      coupon.discountType = discountType.value;
      coupon.startDate = startDateTextField.text.trim().isEmpty ? null : startDate.value;
      coupon.endDate = startDateTextField.text.trim().isEmpty ? null : endDateTextField.text.trim().isEmpty ? null : endDate.value;
      coupon.isActive = isActive.value;
      coupon.updateAt = DateTime.now();

      // Call Repository to Create New User
      await CouponRepository.instance.updateItemRecord(coupon);

      // Update All Data list
      CouponController.instance.updateItemFromLists(coupon);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Return
      Get.back();

      // Success Message & Redirect
      TLoaders.successSnackBar(title: TTexts.congratulations.tr, message: TTexts.recordUpdated.tr);
    } catch (e) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: e.toString());
    }
  }

  /// Method to reset fields
  void resetFields() {
    code.clear();
    description.clear();
    discountValue.clear();
    usageLimit.clear();
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
    isLoading(false);
    isActive.value = true;
  }
}
