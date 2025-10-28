import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';

import '../../../../data/repositories/banners/banners_repository.dart';

import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../data_management/models/brand_model.dart';
import '../../../data_management/models/category_model.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';
import '../../../product_management/models/product_model.dart';
import '../../models/banner_model.dart';
import 'banner_controller.dart';

import 'package:t_utils/t_utils.dart';

class CreateBannerController extends GetxController {
  static CreateBannerController get instance => Get.find();

  final isLoading = false.obs;
  final isActive = true.obs;
  final isFeatured = true.obs;

  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final targetTypeController = TextEditingController();
  final description = TextEditingController();
  final startDateTextField = TextEditingController();
  final endDateTextField = TextEditingController();
  final customUrlWebNameTextField = TextEditingController();
  final customUrlTextField = TextEditingController();
  final imageUrl = ''.obs;
  final bannerTargetType = BannerTargetType.none.obs;
  final bannerTargetTitle = ''.obs;
  final bannerTargetId = ''.obs;
  final startDate = DateTime.now().obs;
  final endDate = DateTime.now().obs;

  final selectedProduct = ProductModel.empty().obs;
  final selectedCategory = CategoryModel.empty().obs;
  final selectedBrand = BrandModel.empty().obs;

  final bannerController = Get.put(BannerController());
  final repository = Get.put(BannerRepository());

  /// Register new Banner
  Future<void> createBanner() async {
    try {
      // Start Loading
      isLoading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }

      if (imageUrl.isEmpty) throw TTexts.selectBannerImage.tr;
      if (endDate.value.isBefore(startDate.value)) throw TTexts.chooseStartEndDatesProperly.tr;

      _setTargetScreen();

      // Map Data
      final newRecord = BannerModel(
        id: '',
        title: title.text.trim(),
        description: description.text.trim(),
        imageUrl: imageUrl.value,
        targetId: bannerTargetId.value,
        targetType: bannerTargetType.value,
        targetTitle: bannerTargetTitle.value,
        customUrl: customUrlTextField.text.trim(),
        clicks: 0,
        isActive: isActive.value,
        isFeatured: isFeatured.value,
        startDate: startDateTextField.text.trim().isEmpty ? null : startDate.value,
        endDate: startDateTextField.text.trim().isEmpty
            ? null
            : endDateTextField.text.trim().isEmpty
                ? null
                : endDate.value,
        createdAt: DateTime.now(),
        updateAt: DateTime.now(),
      );

      // Call Repository to Create New Banner
      newRecord.id = await repository.addNewItem(newRecord);

      // Update All Data list
      bannerController.insertItemAtStartInLists(newRecord);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Return
      Get.back();

      // Success Message & Redirect
      TNotificationOverlay.success(context: Get.context!, title: TTexts.bannerCreatedSuccessfully.tr);
    } catch (e) {
      isLoading.value = false;
      TNotificationOverlay.error(context: Get.context!, title: e.toString());
    }
  }

  void _setTargetScreen() {
    if (bannerTargetType.value == BannerTargetType.productScreen) {
      if (selectedProduct.value.id.isEmpty) throw TTexts.selectProductAsBannerTarget.tr;
      bannerTargetId.value = selectedProduct.value.id;
      bannerTargetTitle.value = selectedProduct.value.title;
    } else if (bannerTargetType.value == BannerTargetType.categoryScreen) {
      if (selectedCategory.value.id.isEmpty) throw TTexts.selectCategoryAsBannerTarget.tr;
      bannerTargetId.value = selectedCategory.value.id;
      bannerTargetTitle.value = selectedCategory.value.name;
    } else if (bannerTargetType.value == BannerTargetType.brandScreen) {
      if (selectedBrand.value.id.isEmpty) throw TTexts.selectBrandAsBannerTarget.tr;
      bannerTargetId.value = selectedBrand.value.id;
      bannerTargetTitle.value = selectedBrand.value.name;
    } else if (bannerTargetType.value == BannerTargetType.customUrl) {
      if (customUrlTextField.text.trim().isEmpty) throw TTexts.addUrlAsBannerTarget.tr;
      bannerTargetId.value = '';
      bannerTargetTitle.value = customUrlWebNameTextField.text.trim().isEmpty ? TTexts.customUrl.tr : customUrlWebNameTextField.text.trim();
    } else {
      bannerTargetId.value = '';
      // bannerTargetTitle.value = selectedRetailer.value.name.isNotEmpty
      //     ? selectedRetailer.value.name[0] + (selectedRetailer.value.name.length > 1 ? selectedRetailer.value.name.substring(1) : '')
      //     : '';
    }
  }

  /// Pick Image from Media
  Future<void> pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    // Handle the selected images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      // Set the selected image to the main image or perform any other action
      imageUrl.value = selectedImages.first.url;
    }
  }

  /// Method to reset fields
  void resetFields() {
    title.clear();
    description.clear();
    imageUrl.value = '';
    bannerTargetTitle.value = '';
    bannerTargetId.value = '';
    bannerTargetType.value = BannerTargetType.homeScreen;
    startDateTextField.clear();
    endDateTextField.clear();
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
    isLoading(false);
    isActive.value = true;
    selectedBrand.value = BrandModel.empty();
    selectedCategory.value = CategoryModel.empty();
    selectedProduct.value = ProductModel.empty();
  }
}
