import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/products/products_repository.dart';
import '../../../../data/repositories/products/recommended_products_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/product_model.dart';
import '../../models/product_variation_model.dart';
import '../product/product_variations_controller.dart';

class RecommendedProductController extends TBaseTableController<ProductModel> {
  static RecommendedProductController get instance => Get.find();

  final RecommendedProductsRepository productRepository = Get.put(RecommendedProductsRepository());
  final ProductVariationController productVariationController = Get.put(ProductVariationController());

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
    if (item.isRecommended == toggle) return null;

    item.isRecommended = toggle;
    await productRepository.updateSingleItemRecord(item.id, {'isRecommended': toggle});
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
    // Now, delete the brand itself
    await ProductRepository.instance.deleteItemRecord(item);
  }

  int stockTotal(ProductType productType, int stock, List<ProductVariationModel> variations) {
    if (productType == ProductType.simple) {
      return stock;
    } else {
      return variations.fold<int>(0, (previousValue, newValue) => previousValue + newValue.stock);
    }
  }

  bool isProductInStock(ProductType productType, int stock, List<ProductVariationModel> variations) {
    bool productInStock = false;

    if (productType == ProductType.simple) {
      productInStock = stock > 0 ? true : false;
    } else {
      productInStock = variations.any((variation) => variation.stock > 0 ? true : false);
    }

    return productInStock;
  }

  bool isProductOnSale(ProductType productType, int salePrice) {
    bool productOnSale = false;

    if (productType == ProductType.simple) {
      productOnSale = salePrice > 0 ? true : false;
    } else {
      productOnSale = productVariationController.productVariations.any((variation) => variation.salePrice > 0 ? true : false);
    }

    return productOnSale;
  }

  /// Get the product price or price range for variations.
  String getProductPrice(ProductModel product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    // If no variations exist, return the simple price or sale price
    if (product.productType.name == ProductType.simple.name || product.variations!.isEmpty) {
      return '\$${(product.salePrice ?? 0) > 0.0 ? product.salePrice : product.price}';
    } else {
      // Calculate the smallest and largest prices among variations
      for (var variation in product.variations!) {
        // Determine the price to consider (sale price if available, otherwise regular price)
        double priceToConsider = variation.salePrice > 0.0 ? variation.salePrice : variation.price;

        // Update smallest and largest prices
        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }

        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }

      // If smallest and largest prices are the same, return a single price
      if (smallestPrice.isEqual(largestPrice)) {
        return largestPrice.toString();
      } else {
        // Otherwise, return a price range
        return '\$$smallestPrice - \$$largestPrice';
      }
    }
  }

  /// Calculate the maximum discount percentage for either simple or variable products.
  String? getMaxDiscountPercentage(ProductModel product) {
    double maxDiscountPercentage = 0.0;

    // If no variations exist, calculate discount for simple product
    if (product.productType.name == ProductType.simple.name || product.variations!.isEmpty) {
      return calculateSalePercentage(product.price, product.salePrice);
    } else {
      // Loop through each variation to find the maximum discount percentage
      for (var variation in product.variations!) {
        if (variation.salePrice > 0.0 && variation.price > 0.0) {
          double discountPercentage = ((variation.price - variation.salePrice) / variation.price) * 100;

          // Update maxDiscountPercentage if the current variation has a higher discount
          if (discountPercentage > maxDiscountPercentage) {
            maxDiscountPercentage = discountPercentage;
          }
        }
      }

      // Return the highest discount percentage found
      return maxDiscountPercentage > 0.0 ? maxDiscountPercentage.toStringAsFixed(0) : null;
    }
  }

  /// -- Calculate Discount Percentage for simple product
  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  /// -- Calculate Product Sold Quantity
  String getProductSoldQuantity(ProductModel product) {
    return product.productType.name == ProductType.simple.name
        ? product.soldQuantity.toString()
        : product.variations!.fold<int>(0, (previousValue, element) => previousValue + element.soldQuantity).toString();
  }
}
