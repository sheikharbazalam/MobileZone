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

class CreateCategoryController extends GetxController {
  static CreateCategoryController get instance => Get.find();

  final selectedParent = CategoryModel.empty().obs;
  final isLoading = false.obs;
  RxString imageURL = ''.obs;
  final isActive = true.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final subCategoryFormKey = GlobalKey<FormState>();
  final repository = Get.put(CategoryRepository());
  final categoryController = Get.put(CategoryController());

  /// Register new Category
  Future<void> createCategory() async {
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
      final newRecord = CategoryModel(
        id: '',
        imageURL: imageURL.value,
        name: name.text.trim(),
        isActive: isActive.value,
        createdAt: DateTime.now(),
        isFeatured: isFeatured.value,
      );

      // Call Repository to Create New Category
      newRecord.id = await repository.addNewItem(newRecord);

      // Update All Data list
      categoryController.insertItemAtStartInLists(newRecord);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Success Message & Redirect
      TNotificationOverlay.success(context: Get.context!, title: 'Category Created', duration: Duration(seconds: 3));

      // Return
      Get.back();
    } catch (e) {
      isLoading.value = false;
      TNotificationOverlay.error(context: Get.context!, title: 'Oh Snap', subTitle: e.toString());
    }
  }

  /// Register new Category
  Future<void> createSubCategory() async {
    try {
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) throw TTexts.networkRequestFailed.tr;

      // Form Validation
      if (!subCategoryFormKey.currentState!.validate()) return;

      // Make sure parentId is selected, else return
      if (selectedParent.value.id.isEmpty) throw TTexts.chooseParentForSubCategory.tr;

      // Start Loading
      isLoading.value = true;

      // Map Data
      final newRecord = CategoryModel(
        id: '',
        imageURL: imageURL.value,
        name: name.text.trim(),
        isActive: isActive.value,
        createdAt: DateTime.now(),
        isFeatured: isFeatured.value,
        parentId: selectedParent.value.id,
      );

      // Call Repository to Create New Category
      newRecord.id = await repository.addNewItem(newRecord);

      // Update All Data list
      CategoryController.instance.insertItemAtStartInLists(newRecord);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      TNotificationOverlay.success(context: Get.context!, title: TTexts.subCategoryCreated.tr, duration: Duration(seconds: 3));

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
    isActive.value = true;
    name.clear();
    imageURL.value = '';
  }
}
