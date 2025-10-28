import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../data/repositories/reviews/reviews_repository.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../models/product_model.dart';
import 'review_controller.dart';

class CreateReviewController extends GetxController {
  static CreateReviewController get instance => Get.find();

  final isLoading = false.obs;
  final isApproved = true.obs;

  final formKey = GlobalKey<FormState>();
  final rating = 0.0.obs;
  final review = TextEditingController();

  final selectedProduct = ProductModel.empty().obs;

  final reviewController = Get.put(ReviewController());
  final repository = Get.put(ReviewRepository());

  /// Register new Review
  Future<void> createReview() async {
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

      if (rating.value == 0 && review.text.trim().isEmpty) return;

      final newReview = await repository.submitReview(
        rating: rating.value,
        comment: review.text.trim(),
        product: selectedProduct.value,
        isApproved: isApproved.value,
      );

      // Update All Data list
      reviewController.insertItemAtStartInLists(newReview);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Success Message & Redirect
      TNotificationOverlay.success(context: Get.context!, title:  TTexts.reviewCreated.tr, duration: Duration(seconds: 3));

      // Return
      Get.back();
    } catch (e) {
      isLoading.value = false;
      TNotificationOverlay.error(context: Get.context!, title: TTexts.ohSnap.tr, subTitle: e.toString());
    }
  }

  /// Method to reset fields
  void resetFields() {
    review.clear();
    isLoading(false);
    rating(0);
    isApproved(false);
    selectedProduct.value = ProductModel.empty();
  }
}
