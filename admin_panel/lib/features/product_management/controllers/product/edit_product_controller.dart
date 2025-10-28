import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';

import 'package:t_utils/t_utils.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';

// Import necessary controllers, models, and utility classes
import '../../../../data/repositories/products/products_repository.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../../data_management/controllers/brand/brand_controller.dart';
import '../../../data_management/controllers/category/category_controller.dart';
import '../../../data_management/models/brand_model.dart';
import '../../../data_management/models/category_model.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../models/product_model.dart';
import 'product_attributes_controller.dart';
import 'product_controller.dart';
import 'product_images_controller.dart';
import 'product_variations_controller.dart';

class EditProductController extends GetxController {
  static EditProductController get instance => Get.find();

  final isActive = true.obs;
  final isLoading = false.obs;
  final publishProduct = true.obs;
  final productType = ProductType.simple.obs;

  final repository = Get.put(ProductRepository());
  final stockPriceFormKey = GlobalKey<FormState>();
  final titleDescriptionFormKey = GlobalKey<FormState>();
  final variationsController = Get.put(ProductVariationController());
  final attributesController = Get.put(ProductAttributesController());
  final imagesController = Get.put(ProductImagesController());
  final productController = Get.put(ProductController());

  // Text editing controllers for input fields
  TextEditingController sku = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController brandTextField = TextEditingController();
  TextEditingController retailerTextField = TextEditingController();
  TTextController  productDescriptionController = TTextController();

  final descriptionController = quill.QuillController(
    readOnly: true,
    document: quill.Document(),
    selection: const TextSelection.collapsed(offset: 0),
  );

  // This will store the list of tags
  RxList<String> tags = <String>[].obs;
  final FocusNode tagFocusNode = FocusNode();
  TextEditingController tagTextField = TextEditingController();

  // Rx observables for selected brand and categories
  final Rx<BrandModel?> selectedBrand = Rx<BrandModel?>(null);
  RxList<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  final Rx<String> productId = ''.obs;
  final Rx<ProductModel> product = ProductModel.empty().obs;

  /// Fetch Product Details
  Future<void> init() async {
    try {
      // Set loading state while initializing data
      isLoading.value = true;

      // If product is empty, fetch using product Id from Firebase
      if (product.value.id.isEmpty) {
        // If Product Id is also empty, redirect
        if (productId.value.isEmpty) Get.offNamed(TRoutes.products);

        // Fetch product details
        product.value = await repository.getSingleItem(productId.value);
      }

      // Initialize Product
      initProductData(product.value);
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      isLoading.value = false; // Set loading state back to false after initialization
    }
  }

  /// Method to add a tag if it doesn't already exist
  void addTag(String tag) {
    // Remove trailing comma and trim the tag
    String cleanedTag = tag.trim().replaceAll(',', '');

    // Check if tag is not empty and doesn't already exist in the list
    if (cleanedTag.isNotEmpty && !tags.contains(cleanedTag)) {
      tags.add(cleanedTag.trim().toLowerCase());
      tagTextField.clear();
      FocusScope.of(Get.context!).requestFocus(tagFocusNode);
    }
  }

  /// Function to handle text input
  void handleTextInput(String input) {
    // Check if input contains a comma
    if (input.endsWith(',')) {
      addTag(input); // Add the tag
    }
  }

  // Method to remove a tag
  void removeTag(String tag) {
    tags.remove(tag);
  }

  /// Method to toggle the selection of categories values
  void toggleCategories(CategoryModel value) {
    if (selectedCategories.map((category) => category.id).contains(value.id)) {
      selectedCategories.remove(value);
    } else {
      selectedCategories.add(value);
    }
  }

  /// Initialize Product Data
  void initProductData(ProductModel product) {
    // Basic Information
    title.text = product.title;
    description.text = product.description ?? '';
    productDescriptionController.setDescription(product.description ?? '');
    productType.value = product.productType.name == ProductType.simple.name ? ProductType.simple : ProductType.variable;

    // Stock & Pricing
    sku.text = product.sku ?? '';
    price.text = (product.price).toString();
    salePrice.text = (product.salePrice ?? 0).toString();

    // Thumbnail & Additional Product Images
    imagesController.selectedThumbnailImageUrl.value = product.thumbnail;
    imagesController.additionalProductImagesUrls.assignAll(product.images?.toList() ?? []);

    stock.text = product.stock.toString();

    // Product Brand
    selectedBrand.value = product.brand;
    brandTextField.text = product.brand?.name ?? '';

    // Tags
    tags.assignAll(product.tags?.toList() ?? []);

    // Categories
    selectedCategories.assignAll(product.categories?.toList() ?? []);

    // Product Unit

    // Product Attributes & Variations (assuming you have a method to fetch variations in ProductVariationController)
    attributesController.productAttributes.assignAll(product.attributes?.toList() ?? []);
    variationsController.productVariations.assignAll(product.variations?.toList() ?? []);
    variationsController.initializeVariationControllers(product.variations?.toList() ?? []);

    // Status & Visibility
    isActive.value = product.isActive;
    publishProduct.value = !product.isDraft;
  }

  // Function to create a new product
  Future<void> updateProduct() async {
    try {
      final product = this.product.value;

      // Store the old categories and brand before the update
      final oldCategories = product.categories;
      final oldBrand = product.brand;

      // Show progress dialog
      showProgressDialog();

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Validate title and description form
      if (!titleDescriptionFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Validate stock and pricing form if ProductType = Single
      if (productType.value == ProductType.simple && !stockPriceFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Validate stock and pricing form if ProductType = Single
      if (productType.value == ProductType.simple &&
          ((double.tryParse(price.text.trim()) ?? 0) <= (double.tryParse(salePrice.text.trim()) ?? 0))) {
        throw TTexts.salePriceCannotBeGreater.tr;
      }

      // Ensure a brand is selected
      // if (selectedBrand.value == null) throw 'Select Brand for this product';

      // Check variation data if ProductType = Variable
      if (productType.value == ProductType.variable && ProductVariationController.instance.productVariations.isEmpty) {
        throw TTexts.noVariationsFound.tr;
      }
      if (productType.value == ProductType.variable) {
        final variationCheckFailed = ProductVariationController.instance.productVariations.any(
          (element) =>
              element.price.isNaN ||
              element.price < 0 ||
              element.salePrice.isNaN ||
              element.salePrice < 0 ||
              element.stock.isNaN ||
              element.stock < 0,
        );

        if (variationCheckFailed) throw TTexts.variationDataNotAccurate.tr;

        // Check if any of the sale price is higher or equal to the price.
        final priceValidationCheckFailed =
            ProductVariationController.instance.productVariations.any((element) => element.salePrice >= element.price);

        if (priceValidationCheckFailed) {
          throw TTexts.variationDiscountedPriceGreater.tr;
        }

        // Reset simple product type fields
        price.text = '';
        salePrice.text = '';
        stock.text = '';
        sku.text = '';
      }

      // Upload Product Thumbnail Image
      final imagesController = ProductImagesController.instance;
      if (imagesController.selectedThumbnailImageUrl.value == null) throw TTexts.selectProductThumbnail.tr;


      // Is Out of stock
      bool isOutOfStock = false;
      if (productType.value == ProductType.simple && (int.tryParse(stock.text.trim()) ?? 0) < 1) isOutOfStock = true;

      product.title = title.text.trim();
      product.lowerTitle = title.text.trim().toLowerCase();
      product.description = productDescriptionController.getDescription();
      product.sku = sku.text.trim();
      product.price = double.tryParse(price.text.trim()) ?? 0;
      product.salePrice = double.tryParse(salePrice.text.trim()) ?? 0;

      product.productType = productType.value;

      product.thumbnail = imagesController.selectedThumbnailImageUrl.value ?? '';
      product.images = imagesController.additionalProductImagesUrls.toList();

      product.stock = int.tryParse(stock.text.trim()) ?? 0;
      product.isOutOfStock = isOutOfStock;
      product.soldQuantity = 0;

      product.tags = tags.toList();
      product.brand = selectedBrand.value;
      product.categories = selectedCategories.toList();
      product.categoryIds = selectedCategories.expand((category) => [category.id, category.parentId]).where((id) => id.isNotEmpty).toSet().toList();
      product.attributes = ProductAttributesController.instance.productAttributes.toList();
      product.variations = ProductVariationController.instance.productVariations.toList();

      product.isDraft = !publishProduct.value;

      product.updatedAt = DateTime.now();
      product.updatedBy = UserController.instance.user.value.id;

      // Call Repository to Update New Product
      await ProductRepository.instance.updateItemRecord(product);

      // Update Product List
      ProductController.instance.updateItemFromLists(product);

      // Update Brand & Categories Count
      await updateBrandAndCategoryCounts(oldBrand, selectedBrand.value, oldCategories ?? [], selectedCategories);

      // Close the Progress Loader
      TFullScreenLoader.stopLoading();

      // Show Success Message Loader
      showCompletionDialog();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TNotificationOverlay.error(context: Get.context!, title: TTexts.ohSnap.tr, subTitle: e.toString());
    }
  }

  Future<void> updateBrandAndCategoryCounts(
      BrandModel? oldBrand, BrandModel? newBrand, List<CategoryModel> oldCategories, List<CategoryModel> newCategories) async {
    final categoryController = Get.put(CategoryController());
    final brandController = Get.put(BrandController());

    // Adjust brand count
    if (oldBrand != null && oldBrand.id != newBrand?.id) {
      // Decrease count from old brand
      oldBrand.productsCount = (oldBrand.productsCount ?? 0) - 1;
      await brandController.brandRepository.updateSingleItemRecord(oldBrand.id, {'productsCount': oldBrand.productsCount});
    }
    if (newBrand != null && oldBrand?.id != newBrand.id) {
      // Increase count for new brand
      newBrand.productsCount = (newBrand.productsCount ?? 0) + 1;
      await brandController.brandRepository.updateSingleItemRecord(newBrand.id, {'productsCount': newBrand.productsCount});
    }

    // Adjust category count
    for (var oldCategory in oldCategories) {
      if (!newCategories.contains(oldCategory)) {
        // Decrease count for old categories no longer in the product
        oldCategory.numberOfProducts = (oldCategory.numberOfProducts) - 1;
        await categoryController.categoryRepository.updateSingleItemRecord(oldCategory.id, {'numberOfProducts': oldCategory.numberOfProducts});
      }
    }
    for (var newCategory in newCategories) {
      if (!oldCategories.contains(newCategory)) {
        // Increase count for new categories added to the product
        newCategory.numberOfProducts = (newCategory.numberOfProducts) + 1;
        await categoryController.categoryRepository.updateSingleItemRecord(newCategory.id, {'numberOfProducts': newCategory.numberOfProducts});
      }
    }
  }

  // Reset form values and flags
  void resetValues() {
    isLoading.value = false;
    productType.value = ProductType.simple;
    publishProduct.value = false;
    stockPriceFormKey.currentState?.reset();
    titleDescriptionFormKey.currentState?.reset();
    title.clear();
    description.clear();
    stock.clear();
    price.clear();
    salePrice.clear();
    brandTextField.clear();
    selectedBrand.value = null;
    selectedCategories.clear();
    ProductVariationController.instance.resetAllValues();
    ProductAttributesController.instance.resetProductAttributes();
  }

  // Show the progress dialog
  void showProgressDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(TTexts.updatingProduct.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(TImages.creatingProductIllustration, height: 200, width: 200),
              SizedBox(height: TSizes().spaceBtwItems),
              buildCheckbox(TTexts.thumbnailImage.tr, true),
              buildCheckbox(TTexts.additionalImages.tr, true),
              buildCheckbox(TTexts.productDataAttributesVariations.tr, true),
              buildCheckbox(TTexts.productCategories.tr, true),
              SizedBox(height: TSizes().spaceBtwItems),
              Text(TTexts.sitTightProductUploading.tr),
            ],
          ),
        ),
      ),
    );
  }

  // Build a checkbox widget
  Widget buildCheckbox(String label, bool value) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          child: value
              ? const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.blue)
              : const Icon(CupertinoIcons.checkmark_alt_circle),
        ),
        SizedBox(width: TSizes().spaceBtwItems),
        Text(label),
      ],
    );
  }

  // Show completion dialog
  void showCompletionDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(TTexts.congratulations.tr),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: Text(TTexts.goToProducts.tr))
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(TImages.productsIllustration, height: 200, width: 200),
            SizedBox(height: TSizes().spaceBtwItems),
            Text(TTexts.congratulations.tr, style: Theme.of(Get.context!).textTheme.headlineSmall),
            SizedBox(height: TSizes().spaceBtwItems),
            Text(TTexts.yourProductCreatedSuccessfully.tr),
          ],
        ),
      ),
    );
  }

  // Extract the content from the QuillController as JSON
  String getDescription() {
    final jsonContent = jsonEncode(descriptionController.document.toDelta().toJson());
    return jsonContent.toString(); // You can save this as a string in your database
  }

  // Extract the content from the QuillController as JSON
  void setDescription(String descriptionJsonString) {
    if (descriptionJsonString.isEmpty) return;
    // Decode the JSON string into a Delta
    final List<dynamic> json = jsonDecode(descriptionJsonString);

    // Set the content into the QuillController
    descriptionController.document = quill.Document.fromJson(json);
  }
}
