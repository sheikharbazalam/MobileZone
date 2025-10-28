import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';

import '../../../../data/repositories/categories/category_repository.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';
import '../../models/category_model.dart';
import 'category_controller.dart';

import 'package:t_utils/t_utils.dart';

class EditCategoryController extends GetxController {
  static EditCategoryController get instance => Get.find();

  // Inject the repository
  final CategoryRepository categoryRepository = Get.put(CategoryRepository());

  final selectedParent = CategoryModel.empty().obs;
  final isLoading = false.obs;
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  final isActive = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final category = CategoryModel.empty().obs;
  final categoryId = ''.obs;

  /// Init Data
  Future<void> init() async {
    try {
      // Fetch record if argument was null
      if (category.value.id.isEmpty) {
        isLoading.value = true;
        category.value = await categoryRepository.getSingleItem(categoryId.value);
      }

      // Select Parent Id
      if (category.value.parentId.isNotEmpty) {
        selectedParent.value = CategoryController.instance.allItems.where((c) => c.id == category.value.parentId).single;
      }
      name.text = category.value.name;
      imageURL.value = category.value.imageURL;
      isActive.value = category.value.isActive;
      isFeatured.value = category.value.isFeatured;
    } catch (e) {
      if (kDebugMode) printError(info: e.toString());
      TNotificationOverlay.error(context: Get.context!, title: TTexts.ohSnap.tr, subTitle: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Register new Category
  Future<void> updateCategory(CategoryModel category) async {
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

      // Map Data
      category.imageURL = imageURL.value;
      category.name = name.text.trim();
      category.parentId = selectedParent.value.id;
      category.isFeatured = isFeatured.value;
      category.isActive = isActive.value;
      category.updatedAt = DateTime.now();

      // Call Repository to Create New User
      await CategoryRepository.instance.updateItemRecord(category);

      // Update All Data list
      CategoryController.instance.updateItemFromLists(category);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Success Message & Redirect
      TNotificationOverlay.success(context: Get.context!, title: TTexts.categoryUpdated.tr, duration: Duration(seconds: 3));

      // Return
      Get.back();
    } catch (e) {
      isLoading.value = false;
      TNotificationOverlay.error(context: Get.context!, title: TTexts.ohSnap.tr, subTitle: e.toString());
    }
  }

  Future<void> updateSubCategory(CategoryModel category) async {
    try {
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) throw TTexts.networkRequestFailed.tr;

      // Form Validation
      if (!formKey.currentState!.validate()) throw TTexts.invalidFormDetails.tr;

      if (selectedParent.value.id.isEmpty) throw TTexts.parentCategoryEmpty.tr;

      // Start Loading
      isLoading.value = true;

      // Map Data
      category.imageURL = imageURL.value;
      category.name = name.text.trim();
      category.parentId = selectedParent.value.id;
      category.isFeatured = isFeatured.value;
      category.isActive = isActive.value;
      category.updatedAt = DateTime.now();

      // Call Repository to Create New User
      await CategoryRepository.instance.updateItemRecord(category);

      // Update All Data list
      CategoryController.instance.updateItemFromLists(category);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Success Message & Redirect
      TNotificationOverlay.success(context: Get.context!, title: TTexts.subCategoryUpdated.tr, duration: Duration(seconds: 3));

      // Return
      Get.back();
    } catch (e) {
      isLoading.value = false;
      TNotificationOverlay.error(context: Get.context!, title: TTexts.ohSnap.tr, subTitle: e.toString());
    }
  }

  /// Pick Thumbnail Image from Media
  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    // Handle the selected images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      // Set the selected image to the main image or perform any other action
      ImageModel selectedImage = selectedImages.first;
      // Update the main image using the selectedImage
      imageURL.value = selectedImage.url;
    }
  }

  /// Method to reset fields
  void resetFields() {
    selectedParent(CategoryModel.empty());
    isLoading(false);
    isFeatured(false);
    name.clear();
    imageURL.value = '';
  }
}
