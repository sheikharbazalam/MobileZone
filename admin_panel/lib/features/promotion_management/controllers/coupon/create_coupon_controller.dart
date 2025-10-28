import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/coupon/coupons_repository.dart';

import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../models/coupon_model.dart';
import 'coupon_controller.dart';

import 'package:t_utils/t_utils.dart';

class CreateCouponController extends GetxController {
  static CreateCouponController get instance => Get.find();

  final isLoading = false.obs;
  final isActive = true.obs;

  final formKey = GlobalKey<FormState>();
  final code = TextEditingController();
  final description = TextEditingController();
  final discountValue = TextEditingController();
  final usageLimit = TextEditingController();
  final discountType = DiscountType.percentage.obs;

  final startDate = DateTime.now().obs;
  final endDate = DateTime.now().obs;
  final startDateTextField = TextEditingController();
  final endDateTextField = TextEditingController();

  final couponController = Get.put(CouponController());
  final repository = Get.put(CouponRepository());

  /// Register new Coupon
  Future<void> createCoupon() async {
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
      final newRecord = CouponModel(
        id: '',
        code: code.text.trim(),
        description: description.text.trim(),
        discountValue: double.tryParse(discountValue.text.trim()) ?? 0.0,
        discountType: discountType.value,
        startDate: startDateTextField.text.trim().isEmpty ? null : startDate.value,
        endDate: startDateTextField.text.trim().isEmpty ? null : endDateTextField.text.trim().isEmpty ? null : endDate.value,
        usageLimit: int.tryParse(usageLimit.text.trim()) ?? -1,
        usageCount: 0,
        isActive: isActive.value,
        createdAt: DateTime.now(),
        updateAt: DateTime.now(),
      );

      // Call Repository to Create New Coupon
      newRecord.id = await repository.addNewItem(newRecord);

      // Update All Data list
      couponController.insertItemAtStartInLists(newRecord);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Return
      Get.back();

      // Success Message & Redirect
      TLoaders.successSnackBar(title: TTexts.congratulations.tr, message: TTexts.newRecordAdded.tr);
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
