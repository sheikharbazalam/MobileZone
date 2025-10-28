import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/brands/brand_repository.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../product_management/controllers/product/product_controller.dart';
import '../../models/brand_model.dart';
import '../category/category_controller.dart';

class BrandController extends TBaseTableController<BrandModel> {
  static BrandController get instance => Get.find();

  // Inject the repository
  final BrandRepository brandRepository = Get.put(BrandRepository());

  // Search
  final searchResult = <BrandModel>[].obs;
  final searchTextField = TextEditingController();

  Future<void> searchBrands(String query) async {
    if (allItems.isEmpty) await fetchData();
    searchResult.assignAll(allItems.where((item) => item.name.toLowerCase().contains(query.toLowerCase())));
  }

  @override
  Future<List<BrandModel>> fetchItems() async {
    // To make sure add more items button is not visible (allFetchedItems < limit)
    limit.value = 10000000;
    return await brandRepository.getAllItems();
  }

  @override
  bool containsSearchQuery(BrandModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase()) ||
        (item.categories != null && item.categories!.any((category) => category.name.toLowerCase().contains(query.toLowerCase())));
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (BrandModel category) => category.name.toLowerCase());
  }

  @override
  Future<BrandModel?> updateStatusToggleSwitch(bool toggle, BrandModel item) async {
    if (item.isActive == toggle) return null;

    item.isActive = toggle;
    await brandRepository.updateSingleItemRecord(item.id, {'isActive': toggle});
    return item;
  }

  @override
  Future<BrandModel?> updateFeaturedToggleSwitch(bool toggle, BrandModel item) async {
    if (item.isFeatured == toggle) return null;

    item.isFeatured = toggle;
    await brandRepository.updateSingleItemRecord(item.id, {'isFeatured': toggle});
    return item;
  }

  @override
  Future<void> deleteItem(BrandModel item) async {
    final categoryController = Get.put(CategoryController());
    final productController = Get.put(ProductController());

    // Step 1: Fetch categories if not already fetched
    if (categoryController.allItems.isEmpty) {
      await categoryController.fetchItems();
    }

    // Step 2: Fetch products if not already fetched
    if (productController.allItems.isEmpty) {
      await productController.fetchItems();
    }

    // Step 3: Check for categories linked to this brand
    final categoriesWithCurrentBrand =
        categoryController.allItems.where((category) => category.brands?.any((brand) => brand.id == item.id) ?? false).toList();

    // Step 4: Check for products linked to this brand
    final productsWithCurrentBrand = productController.allItems.where((product) => product.brand?.id == item.id).toList();

    // Step 5: If products are still linked to the brand, prevent deletion
    if (productsWithCurrentBrand.isNotEmpty) {
      throw Exception(
          TTexts.brandDeleteError.tr);
    }

    // Step 6: Remove brand from linked categories
    for (var category in categoriesWithCurrentBrand) {
      category.brands!.removeWhere((brand) => brand.id == item.id);
      CategoryController.instance.updateItemFromLists(category);
    }

    // Step 7: Update all affected categories concurrently
    await Future.wait(categoriesWithCurrentBrand.map((category) => categoryController.categoryRepository.updateItemRecord(category)));

    // Step 8: Delete the brand itself
    await BrandRepository.instance.deleteItemRecord(item);
  }
}
