import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../data/repositories/brands/brand_repository.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';
import '../../models/brand_model.dart';
import '../../models/category_model.dart';
import '../category/category_controller.dart';
import 'brand_controller.dart';

class CreateBrandController extends GetxController {
  static CreateBrandController get instance => Get.find();

  final isLoading = false.obs;
  RxString imageURL = ''.obs;
  final isActive = true.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final categoryController = Get.put(CategoryController());
  final brandController = Get.put(BrandController());
  final brandRepository = Get.put(BrandRepository());
  final List<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  /// Toggle Category Selection
  void toggleSelection(CategoryModel category) {
    if (selectedCategories.contains(category)) {
      // Unselect the category itself
      selectedCategories.remove(category);

      // If category is a parent, check if it has child categories
      final allChildCategories = categoryController.allItems.where((cat) => cat.parentId == category.id).toList();
      if (allChildCategories.isNotEmpty) {
        // If only one child, remove that child as well
        if (allChildCategories.length == 1) {
          selectedCategories.remove(allChildCategories.first);
        } else {
          // Remove all child categories if parent is removed
          for (var childCategory in allChildCategories) {
            selectedCategories.remove(childCategory);
          }
        }
      }

      // Unselect parent category if it's a child and its parent exists in selected categories
      if (category.parentId.isNotEmpty) {
        final parentCategory = categoryController.allItems.where((cat) => cat.id == category.parentId).singleOrNull;
        if (parentCategory != null && selectedCategories.contains(parentCategory)) {
          selectedCategories.remove(parentCategory);
        }
      }
    } else {
      // Select all sub categories
      final allChildCategories = categoryController.allItems.where((cat) => cat.parentId == category.id).toList();
      // Check if already added else add
      for (var childCategory in allChildCategories) {
        if (!selectedCategories.contains(childCategory)) {
          selectedCategories.add(childCategory);
        }
      }

      selectedCategories.add(category);

      // Check if the category is a child category and its parent should be selected
      if (category.parentId.isNotEmpty) {
        final parentCategory = categoryController.allItems.where((cat) => cat.id == category.parentId).singleOrNull;

        if (parentCategory != null) {
          // Get all child categories of the parent
          final allParentChildCategories = categoryController.allItems.where((cat) => cat.parentId == parentCategory.id).toList();

          // If all children of the parent are selected, add the parent to selectedCategories
          final allChildrenSelected = allParentChildCategories.every((child) => selectedCategories.contains(child));
          if (allChildrenSelected && !selectedCategories.contains(parentCategory)) {
            selectedCategories.add(parentCategory);
          }
        }
      }
    }
  }

  /// Register new Brand
  Future<void> createBrand() async {
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
      final newRecord = BrandModel(
        id: '',
        imageURL: imageURL.value,
        name: name.text.trim(),
        isActive: isActive.value,
        createdAt: DateTime.now(),
        isFeatured: isFeatured.value,
        categories: selectedCategories
            .map((category) => CategoryModel(
                id: category.id,
                name: category.name,
                imageURL: category.imageURL,
                isActive: category.isActive,
                isFeatured: category.isFeatured,
                parentId: category.parentId))
            .toList(),
      );

      // Call Repository to Create New Brand
      newRecord.id = await brandRepository.addNewItem(newRecord);

      // Update categories: add the brand to each selected category
      for (var category in selectedCategories) {
        // Add this brand to the category's brand list
        category.brands ??= [];
        category.brands!.add(newRecord);
        category.brands!.where((brand) => brand.id == newRecord.id).single.categories = [];

        // Update category in database
        await categoryController.categoryRepository.updateItemRecord(category);
      }

      // Assign Categories back to local list
      newRecord.categories = selectedCategories
          .map((category) => CategoryModel(
                id: category.id,
                name: category.name,
                imageURL: category.imageURL,
                isActive: category.isActive,
                isFeatured: category.isFeatured,
                parentId: category.parentId,
              ))
          .toList();

      // Update All Data list
      brandController.insertItemAtStartInLists(newRecord);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Success Message & Redirect
      TNotificationOverlay.success(context: Get.context!, title: 'Brand Created', duration: Duration(seconds: 3));

      // Return
      Get.back();
    } catch (e) {
      isLoading.value = false;
      TNotificationOverlay.error(context: Get.context!, title: 'Oh Snap', subTitle: e.toString());
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
    isLoading(false);
    isFeatured(false);
    isActive.value = true;
    name.clear();
    imageURL.value = '';
    selectedCategories.clear();
  }
}
