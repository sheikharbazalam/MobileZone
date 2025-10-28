import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/products/products_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/product_model.dart';
import '../../models/product_variation_model.dart';
import 'product_variations_controller.dart';

class ProductController extends TBaseTableController<ProductModel> {
  static ProductController get instance => Get.find();

  final ProductRepository productRepository = Get.put(ProductRepository());
  final ProductVariationController productVariationController = Get.put(ProductVariationController());

  // Search
  final searchLoader = false.obs;
  final searchResultLimit = 5.obs;
  final searchResult = <ProductModel>[].obs;
  final searchTextField = TextEditingController();

  Future<void> searchProducts(String query) async {
    searchLoader.value = true;
    try {
      searchResult.value = await productRepository.searchProducts(query);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      searchLoader.value = false;
    }
  }

  @override
  Future<List<ProductModel>> fetchItems() async {
    return await productRepository.fetchPaginatedItems(limit.value);
  }

  @override
  bool containsSearchQuery(ProductModel item, String query) {
    return item.title.toLowerCase().contains(query.toLowerCase()) ||
        (item.brand != null && item.brand!.name.toLowerCase().contains(query.toLowerCase())) ||
        (item.tags != null && item.tags!.any((tag) => tag.toLowerCase().contains(query.toLowerCase()))) ||
        (item.categories != null && item.categories!.any((category) => category.name.toLowerCase().contains(query.toLowerCase())));
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (ProductModel category) => category.title.toLowerCase());
  }

  @override
  Future<ProductModel?> updateStatusToggleSwitch(bool toggle, ProductModel item) async {
    if (item.isActive == toggle) return null;

    item.isActive = toggle;
    await productRepository.updateSingleItemRecord(item.id, {'isActive': toggle});
    return item;
  }

  @override
  Future<ProductModel?> updateFeaturedToggleSwitch(bool toggle, ProductModel item) async {
    item.isFeatured = toggle;
    await productRepository.updateSingleItemRecord(item.id, {'isFeatured': toggle});
    return item;
  }

  @override
  Future<void> deleteItem(ProductModel item) async {
    // Delete the product item from the repository
    await ProductRepository.instance.deleteItemRecord(item);
  }

  int stockTotal(ProductType productType, int stock, List<ProductVariationModel> variations) {
    if (productType == ProductType.simple) {
      return stock;
    } else {
      return variations.fold<int>(0, (previousValue, newValue) => previousValue + newValue.stock);
    }
  }
}
