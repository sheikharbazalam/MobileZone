import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/repositories/categories/category_repository.dart';
import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../product_management/controllers/product/product_controller.dart';
import '../../models/category_model.dart';
import '../brand/brand_controller.dart';

class CategoryController extends TBaseTableController<CategoryModel> {
  static CategoryController get instance => Get.find();

  // Inject the repository
  final CategoryRepository categoryRepository = Get.put(CategoryRepository());

  // Search
  final searchResult = <CategoryModel>[].obs;
  final searchTextField = TextEditingController();

  Future<void> searchCategories(String query) async {
    if (allItems.isEmpty) await fetchData();
    searchResult.assignAll(allItems.where((item) => item.name.toLowerCase().contains(query.toLowerCase())));
  }

  @override
  Future<List<CategoryModel>> fetchItems() async {
    limit.value = 10000000; // To make sure add more items button is not visible (allFetchedItems < limit)
    return await categoryRepository.getAllItems();
  }

  @override
  bool containsSearchQuery(CategoryModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (CategoryModel category) => category.name.toLowerCase());
  }

  @override
  Future<CategoryModel?> updateStatusToggleSwitch(bool toggle, CategoryModel item) async {
    if (item.isActive == toggle) return null;

    item.isActive = toggle;
    await categoryRepository.updateSingleItemRecord(item.id, {'isActive': toggle});
    return item;
  }

  @override
  Future<CategoryModel?> updateFeaturedToggleSwitch(bool toggle, CategoryModel item) async {
    if (item.isFeatured == toggle) return null;

    item.isFeatured = toggle;
    await categoryRepository.updateSingleItemRecord(item.id, {'isFeatured': toggle});
    return item;
  }

  @override
  Future<void> deleteItem(CategoryModel item) async {
    final brandController = Get.put(BrandController());
    final productController = Get.put(ProductController());

    // Step 1: Check if any subcategories exist under this category
    if (allItems.any((i) => i.parentId == item.id)) {
      throw TTexts.subcategoriesExistError.tr;
    }

    // Step 2: Fetch brands and products if not already fetched
    if (brandController.allItems.isEmpty) {
      await brandController.fetchItems();
    }

    if (productController.allItems.isEmpty) {
      await productController.fetchItems();
    }

    // Step 3: Check if any products are linked to this category
    final productsWithCurrentCategory = productController.allItems
        .where((product) => product.categories != null && product.categories!.any((category) => category.id == item.id))
        .toList();

    // Step 4: If products are still linked to the category, prevent deletion
    if (productsWithCurrentCategory.isNotEmpty) {
      throw Exception(
        TTexts.categoryDeleteError.tr,
      );
    }

    // Step 5: Update brands to remove the category
    final brandsWithCurrentCategory =
        brandController.allItems.where((brand) => brand.categories?.any((category) => category.id == item.id) ?? false).toList();

    for (var brand in brandsWithCurrentCategory) {
      brand.categories!.removeWhere((category) => category.id == item.id);
      brandController.updateItemFromLists(brand);
    }

    // Step 6: Update all affected brands concurrently
    await Future.wait(brandsWithCurrentCategory.map((brand) => brandController.brandRepository.updateItemRecord(brand)));

    // Step 7: Proceed with deleting the category itself
    await categoryRepository.deleteItemRecord(item);
  }
}
