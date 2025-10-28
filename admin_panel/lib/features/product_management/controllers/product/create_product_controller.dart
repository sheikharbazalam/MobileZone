import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../data/repositories/products/products_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../data_management/models/brand_model.dart';
import '../../../data_management/models/category_model.dart';
import '../../../data_management/models/unit_model.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../models/product_model.dart';
import 'product_attributes_controller.dart';
import 'product_controller.dart';
import 'product_images_controller.dart';
import 'product_variations_controller.dart';

class CreateProductController extends GetxController {
  static CreateProductController get instance => Get.find();

  final isActive = true.obs;
  final isLoading = false.obs;
  final publishProduct = true.obs;
  final productType = ProductType.simple.obs;

  final repository = Get.put(ProductRepository());
  final stockPriceFormKey = GlobalKey<FormState>();
  final titleDescriptionFormKey = GlobalKey<FormState>();
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
  TTextController productDescriptionController = TTextController();

  final descriptionController = quill.QuillController(
    document: quill.Document(),
    selection: const TextSelection.collapsed(offset: 0),
  );

  // This will store the list of tags
  RxList<String> tags = <String>[].obs;
  final FocusNode tagFocusNode = FocusNode();
  TextEditingController tagTextField = TextEditingController();

  // Rx observables for selected brand and categories
  final Rx<BrandModel?> selectedBrand = Rx<BrandModel?>(null);
  final RxList<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  /// Method to add a tag if it doesn't already exist
  void addTag(String tag) {
    // Remove trailing comma and trim the tag
    String cleanedTag = tag.trim().replaceAll(',', '');

    // Check if tag is not empty and doesn't already exist in the list
    if (cleanedTag.isNotEmpty && !tags.contains(cleanedTag)) {
      tags.add(cleanedTag); // Add tag to the list
      tagTextField.clear(); // Clear the text field
      FocusScope.of(Get.context!).requestFocus(tagFocusNode); // Focus the tag field again
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

  /// Register new Product
  Future<void> createProduct() async {
    try {
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
      if (productType.value == ProductType.simple && ((double.tryParse(price.text.trim()) ?? 0) <= (double.tryParse(salePrice.text.trim()) ?? 0))) {
        throw TTexts.salePriceCannotBeGreater.tr;
      }

      // Ensure a brand is selected
      // if (selectedBrand.value == null) throw 'Select Brand for this product';

      // Check variation data if ProductType = Variable
      if (productType.value == ProductType.variable && ProductVariationController.instance.productVariations.isEmpty) {
        throw TTexts.noVariationsFound.tr;
      }

      if (productType.value == ProductType.variable) {
        // Check fields data
        final variationCheckFailed = ProductVariationController.instance.productVariations.any((element) =>
            element.price.isNaN ||
            element.price < 0 ||
            element.salePrice.isNaN ||
            element.salePrice < 0 ||
            element.stock.isNaN ||
            element.stock < 0 ||
            element.salePrice > element.price);

        if (variationCheckFailed) throw TTexts.variationDataNotAccurate.tr;

        // Check if any of the sale price is higher or equal to the price.
        final priceValidationCheckFailed = ProductVariationController.instance.productVariations.any((element) => element.salePrice >= element.price);

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

      // Product Variation Images
      final variations = ProductVariationController.instance.productVariations;
      if (productType.value == ProductType.simple && variations.isNotEmpty) {
        // If admin added variations and then changed the Product Type, remove all variations
        ProductVariationController.instance.resetAllValues();
        variations.value = [];
      }

      // Is Out of stock
      bool isOutOfStock = false;
      if (productType.value == ProductType.simple && (int.tryParse(stock.text.trim()) ?? 0) < 1) isOutOfStock = true;

      // Map Product Data to ProductModel
      final newRecord = ProductModel(
        id: '',
        sku: sku.text.trim(),
        title: title.text.trim(),
        lowerTitle: title.text.trim().toLowerCase(),
        description: productDescriptionController.getDescription(),
        price: double.tryParse(price.text.trim()) ?? 0,
        salePrice: double.tryParse(salePrice.text.trim()) ?? 0,
        thumbnail: imagesController.selectedThumbnailImageUrl.value ?? '',
        images: imagesController.additionalProductImagesUrls,
        productType: productType.value,
        stock: int.tryParse(stock.text.trim()) ?? 0,
        isOutOfStock: isOutOfStock,
        soldQuantity: 0,
        brand: selectedBrand.value,
        tags: tags,
        categories: selectedCategories,
        // categoryIds: selectedCategories.map((category) => category.id).toList(),
        categoryIds: selectedCategories.expand((category) => [category.id, category.parentId]).where((id) => id.isNotEmpty).toSet().toList(),
        unit: UnitModel.empty(),
        attributes: ProductAttributesController.instance.productAttributes,
        variations: variations,
        isFeatured: true,
        isActive: true,
        isDraft: !publishProduct.value,
        isDeleted: false,
        views: 0,
        rating: 0,
        ratingCount: 0,
        reviewsCount: 0,
        likes: 0,
        createdAt: DateTime.now(),
        createdBy: UserController.instance.user.value.id,
        updatedAt: DateTime.now(),
        updatedBy: UserController.instance.user.value.id,
      );

      // Call Repository to Create New Product
      newRecord.id = await repository.addNewItem(newRecord);

      // Update Product List
      ProductController.instance.insertItemAtStartInLists(newRecord);

      // Close the Progress Loader
      TFullScreenLoader.stopLoading();

      // Show Success Message Loader
      showCompletionDialog();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TNotificationOverlay.error(context: Get.context!, title: 'Oh Snap', subTitle: e.toString());
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
              Text(TTexts.sitTightProductUploading.tr),
            ],
          ),
        ),
      ),
    );
  }

  // Build a checkbox widget
  Widget buildCheckbox(String label, RxBool value) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          child: value.value ? const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.blue) : const Icon(CupertinoIcons.checkmark_alt_circle),
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
            Text(TTexts.yourProductUpdatedSuccessfully.tr),
          ],
        ),
      ),
    );
  }

  // Extract the content from the QuillController as JSON
  String getDescription() {
    final jsonContent = descriptionController.document.toDelta().toJson();
    return jsonContent.toString(); // You can save this as a string in your database
  }

  // Extract the content from the QuillController as JSON
  void setDescription(String descriptionJsonString) {
    // Decode the JSON string into a Delta
    final List<dynamic> json = jsonDecode(descriptionJsonString);

    // Convert the JSON back into a Delta
    final delta = Delta.fromJson(json);

    // Set the content into the QuillController
    descriptionController.document = quill.Document.fromDelta(delta);
  }
}
