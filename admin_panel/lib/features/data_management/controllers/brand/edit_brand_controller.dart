import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';

import '../../../../data/repositories/brands/brand_repository.dart';
import '../../../../data/repositories/categories/category_repository.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';
import '../../models/brand_model.dart';
import '../../models/category_model.dart';
import '../category/category_controller.dart';
import 'brand_controller.dart';

import 'package:t_utils/t_utils.dart';

class EditBrandController extends GetxController {
  static EditBrandController get instance => Get.find();

  // Inject the repository
  final BrandRepository brandRepository = Get.put(BrandRepository());

  final isLoading = false.obs;
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  final isActive = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final brand = BrandModel.empty().obs;
  final brandId = ''.obs;
  final RxList<CategoryModel> selectedCategories = <CategoryModel>[].obs;
  final categoryController = Get.put(CategoryController());

  /// Init Data
  Future<void> init() async {
    try {
      // Fetch record if argument was null
      if (brand.value.id.isEmpty) {
        isLoading.value = true;
        brand.value = await brandRepository.getSingleItem(brandId.value);
      }

      name.text = brand.value.name;
      imageURL.value = brand.value.imageURL;
      isActive.value = brand.value.isActive;
      isFeatured.value = brand.value.isFeatured;
      selectedCategories.assignAll(brand.value.categories ?? []);
    } catch (e) {
      if (kDebugMode) printError(info: e.toString());
      TNotificationOverlay.error(context: Get.context!, title: 'Oh Snap', subTitle: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle Category Selection
  void toggleSelection(CategoryModel category) {
    try {
      if (selectedCategories.map((sc) => sc.id).contains(category.id)) {
        // Unselect the category itself
        selectedCategories.remove(selectedCategories.where((sc) => sc.id == category.id).single);

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
          if (parentCategory != null && selectedCategories.map((sc) => sc.id).contains(parentCategory.id)) {
            selectedCategories.removeWhere((cat) => cat.id == parentCategory.id);
          }
        }
      } else {
        // Select all sub categories
        final allChildCategories = categoryController.allItems.where((cat) => cat.parentId == category.id).toList();
        // Check if already added else add
        for (var childCategory in allChildCategories) {
          if (!selectedCategories.map((sc) => sc.id).contains(childCategory.id)) {
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
            final allChildrenSelected = allParentChildCategories.every((child) => selectedCategories.map((sc) => sc.id).contains(child.id));
            if (allChildrenSelected && !selectedCategories.map((sc) => sc.id).contains(parentCategory.id)) {
              selectedCategories.add(parentCategory);
            }
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Register new Brand
  Future<void> updateBrand(BrandModel brand) async {
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
      brand.imageURL = imageURL.value;
      brand.name = name.text.trim();
      brand.isFeatured = isFeatured.value;
      brand.isActive = isActive.value;
      brand.updatedAt = DateTime.now();
      brand.categories = selectedCategories
          .map((category) => CategoryModel(
              id: category.id,
              name: category.name,
              imageURL: category.imageURL,
              isActive: category.isActive,
              isFeatured: category.isFeatured,
              parentId: category.parentId))
          .toList();

      // Call Repository to Create New User
      await BrandRepository.instance.updateItemRecord(brand);

      // Update All Data list
      BrandController.instance.updateItemFromLists(brand);

      // Update Brand Categories
      await updateBrandCategories(brand);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Success Message & Redirect
      TNotificationOverlay.success(context: Get.context!, title: TTexts.brandUpdated.tr, duration: Duration(seconds: 3));

      // Return
      Get.back();
    } catch (e) {
      isLoading.value = false;
      TNotificationOverlay.error(context: Get.context!, title: TTexts.ohSnap.tr, subTitle: e.toString());
    }
  }

  // Update categories for the brand
  Future<void> updateBrandCategories(BrandModel newRecord) async {
    // Step 1: Get all categories that currently contain the brand
    final currentCategoriesWithBrand = CategoryController.instance.allItems
        .where((category) => category.brands != null && category.brands!.any((brand) => brand.id == newRecord.id))
        .toList();

    // Step 2: Handle removal of the brand from unselected categories
    for (var category in currentCategoriesWithBrand) {
      // If the category is no longer selected, remove the brand from this category
      if (!selectedCategories.map((sc) => sc.id).contains(category.id)) {
        category.brands!.removeWhere((brand) => brand.id == newRecord.id);

        // Update the category in the database
        await CategoryRepository.instance.updateItemRecord(category);
      }
    }

    // Step 3: Handle adding the brand to newly selected categories
    for (var category in selectedCategories) {
      // If the brand is not already in the category's brand list, add it
      category.brands ??= [];
      if (!category.brands!.any((brand) => brand.id == newRecord.id)) {
        final originalCategory = CategoryController.instance.allItems.where((ct) => ct.id == category.id).single;
        newRecord.categories = [];
        originalCategory.brands!.add(newRecord);

        // Update the category in the database
        await CategoryRepository.instance.updateItemRecord(originalCategory);
      }
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
    name.clear();
    imageURL.value = '';
  }
}
