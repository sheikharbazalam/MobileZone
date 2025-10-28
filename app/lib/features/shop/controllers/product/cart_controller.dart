import 'package:get/get.dart';

import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/local_storage/storage_utility.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/cart_item_model.dart';
import '../../models/product_model.dart';
import 'variation_controller.dart';

class CartController extends GetxController {
  static CartController get instance => Get.isRegistered() ? Get.find() : Get.put(CartController());

  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt productQuantityInCart = 0.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  RxBool loading = false.obs;
  final variationController = VariationController.instance;

  CartController() {
    loadCartItems();
  }

  /// This function converts a ProductModel to a CartItemModel
  CartItemModel convertToCartItem(ProductModel product, int quantity) {
    if (product.productType == ProductType.simple) {
      // Reset Variation in case of single product type.
      variationController.resetSelectedAttributes();
    }
    final variation = variationController.selectedVariation.value;
    final isVariation = variationController.selectedVariation.value.id.isNotEmpty;
    final price = isVariation ? variation.price : product.price;
    final salePrice =
        isVariation
            ? variation.salePrice > 0.0
                ? variation.salePrice
                : 0.0
            : product.salePrice! > 0.0
            ? product.salePrice
            : 0.0;
    // final price = isVariation
    //     ? (variation.salePrice > 0.0 ? variation.salePrice : variation.price)
    //     : ((product.salePrice ?? 0.0) > 0.0 ? product.salePrice ?? 0.0 : product.price);

    return CartItemModel(
      productId: product.id,
      title: product.title,
      price: price,
      salePrice: salePrice!,
      quantity: quantity,
      variationId: variation.id,
      image: isVariation ? variation.image.value : product.thumbnail,
      brandName: product.brand != null ? product.brand!.name : '',
      selectedVariation: isVariation ? variation.attributeValues : null,
    );
  }

  void addToCart(ProductModel product) {
    // Variation Selected?
    if (product.productType.name == ProductType.variable.name && variationController.selectedVariation.value.id.isEmpty) {
      TLoaders.customToast(message: TTexts.selectVariations.tr);
      return;
    }
    if (product.productType.name == ProductType.variable.name) {
      if (variationController.selectedVariation.value.stock < 1) {
        TLoaders.warningSnackBar(message: TTexts.selectVariationsOutOfStock.tr, title: TTexts.ohSnap.tr);
        return;
      }
    } else {
      if (product.stock < 1) {
        TLoaders.warningSnackBar(message: TTexts.selectProductOutOfStock.tr, title: TTexts.ohSnap.tr);
        return;
      }
    }

    // Quantity Check
    // productQuantityInCart.value++;

    // Convert the ProductModel to a CartItemModel with the given quantity
    final selectedCartItem = convertToCartItem(product, productQuantityInCart.value);

    // Check if already added in the Cart
    int index = cartItems.indexWhere(
      (cartItem) => cartItem.productId == selectedCartItem.productId && cartItem.variationId == selectedCartItem.variationId,
    );

    if (index >= 0) {
      // This quantity is already added or Updated/Removed from the design (Cart)(-)
      cartItems[index].quantity = selectedCartItem.quantity;
    } else {
      cartItems.add(selectedCartItem);
    }

    updateCart();
    TLoaders.customToast(message: TTexts.productAddedToCart.tr);
  }

  void addOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere(
      (cartItem) => cartItem.productId == item.productId && cartItem.variationId == item.variationId,
    );

    if (index >= 0) {
      cartItems[index].quantity += 1;
    } else {
      cartItems.add(item);
    }

    updateCart();
  }

  void removeOneFromCart(CartItemModel item) {
    int index = cartItems.indexWhere(
      (cartItem) => cartItem.productId == item.productId && cartItem.variationId == item.variationId,
    );

    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
      } else {
        // Show dialog before completely removing
        cartItems[index].quantity == 1 ? removeFromCartDialog(index) : cartItems.removeAt(index);
      }
      productQuantityInCart--;
      updateCart();
    }
  }

  void removeFromCartDialog(int index) {
    Get.defaultDialog(
      title: TTexts.removeProduct.tr,
      middleText: TTexts.removeProductSure.tr,
      onConfirm: () {
        // Remove the item from the cart
        cartItems.removeAt(index);
        updateCart();
        TLoaders.customToast(message: TTexts.productRemoveFromCart.tr);
        Get.back();
      },
      onCancel: () => () => Get.back(),
    );
  }

  void replaceCartItem() {
    Get.defaultDialog(
      title: TTexts.removeProduct.tr,
      middleText: TTexts.removeStoreCartProduct.tr,
      onConfirm: () {
        // Remove the item from the cart
        cartItems.clear();
        updateCart();
        TLoaders.customToast(message: TTexts.productRemoveFromCart.tr);
        Get.back();
      },
      onCancel: () => () => Get.back(),
    );
  }

  void updateCart() {
    updateCartTotals();
    saveCartItems();
    cartItems.refresh();
  }

  void loadCartItems() async {
    loading.value = true;
    final cartItemStrings = TLocalStorage.instance().readData<List<dynamic>>('cartItems');
    if (cartItemStrings != null) {
      cartItems.assignAll(cartItemStrings.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)));
      updateCartTotals();
    }
    loading.value = false;
  }

  void updateCartTotals() {
    double calculatedTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for (var item in cartItems) {
      calculatedTotalPrice += (item.salePrice > 0.0 ? item.salePrice : item.price) * item.quantity.toDouble();
      calculatedNoOfItems += item.quantity;
    }

    totalCartPrice.value = calculatedTotalPrice;
    noOfCartItems.value = calculatedNoOfItems;
  }

  void saveCartItems() {
    final cartItemStrings = cartItems.map((item) => item.toJson()).toList();
    TLocalStorage.instance().writeData('cartItems', cartItemStrings);
  }

  /// -- Initialize already added Item's Count in the cart.
  void updateAlreadyAddedProductCount(ProductModel product) {
    // If product has no variations then calculate cartEntries and display total number.
    // Else make default entries to 0 and show cartEntries when variation is selected.
    if (product.productType.toString() == ProductType.simple.toString()) {
      productQuantityInCart.value = getProductQuantityInCart(product.id);
    } else {
      // Get selected Variation if any...
      final variationId = variationController.selectedVariation.value.id;
      if (variationId.isNotEmpty) {
        productQuantityInCart.value = getVariationQuantityInCart(product.id, variationId);
      } else {
        productQuantityInCart.value = 0;
      }
    }
  }

  int getProductQuantityInCart(String productId) {
    final foundItem = cartItems
        .where((item) => item.productId == productId)
        .fold(0, (previousValue, element) => previousValue + element.quantity);
    return foundItem;
  }

  int getVariationQuantityInCart(String productId, String variationId) {
    final foundItem = cartItems.firstWhere(
      (item) => item.productId == productId && item.variationId == variationId,
      orElse: () => CartItemModel.empty(),
    );

    return foundItem.quantity;
  }

  void clearCart() {
    productQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }
}
