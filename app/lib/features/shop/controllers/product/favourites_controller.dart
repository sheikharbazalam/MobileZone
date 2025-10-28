import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/product/product_repository.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/local_storage/storage_utility.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/product_model.dart';
import 'product_controller.dart';

class FavouriteController extends GetxController {
  static FavouriteController get instance => Get.find();

  /// Variables
  final favorites = <String, bool>{}.obs;
  TextEditingController textEditingController = TextEditingController();
  final productController = Get.put(ProductController());

  @override
  void onInit() {
    super.onInit();
    // Initialize by fetching the list of already added favorites
    initFavorites();
  }

  // Method to initialize favorites by reading from storage
  Future<void> initFavorites() async {
    final json = TLocalStorage.instance().readData('favorites');
    if (json != null) {
      final storedFavorites = jsonDecode(json) as Map<String, dynamic>;
      favorites.assignAll(storedFavorites.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  /// Method to check if a product is selected (favorite)
  bool isFavourite(String productId) {
    return favorites[productId] ?? false;
  }

  /// Add Product to Favourites
  Future<void> toggleFavoriteProduct(String productId, ProductModel product) async {
    // If favorites do not have this product, Add. Else Toggle
    if (!favorites.containsKey(productId)) {
      favorites[productId] = true;
      saveFavoritesToStorage();
      await productController.addProductLike(productId, product);
      TLoaders.customToast(message: TTexts.productAddedToWishlist.tr);
    } else {
      TLocalStorage.instance().removeData(productId);
      favorites.remove(productId);
      saveFavoritesToStorage();
      await productController.removeProductLike(productId, product);
      favorites.refresh();
      TLoaders.customToast(message:TTexts.productRemoveFromWishlist.tr);
    }
  }

  // Save the updated favorites to storage
  void saveFavoritesToStorage() {
    final encodedFavorites = json.encode(favorites);
    TLocalStorage.instance().writeData('favorites', encodedFavorites);
  }

  /// Method to get the list of favorite products
  Future<List<ProductModel>> favoriteProducts() {
    if (kDebugMode) {
      print(favorites.keys.toList());
    }
    return ProductRepository.instance.getFavouriteProducts(favorites.keys.toList());
  }
}
