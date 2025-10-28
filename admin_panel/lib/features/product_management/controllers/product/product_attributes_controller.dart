import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../../data_management/controllers/attribute/attribute_controller.dart';
import '../../../data_management/models/attribute_model.dart';
import '../../models/product_attribute_model.dart';
import 'product_variations_controller.dart';

class ProductAttributesController extends GetxController {
  static ProductAttributesController get instance => Get.find();

  // Observables for loading state, form key, and product attributes
  final isLoading = false.obs;
  final attributesFormKey = GlobalKey<FormState>();
  final attributeTextField = TextEditingController();
  final selectedAttribute = AttributeModel.empty().obs;
  final selectedAttributeValues = <String>[].obs;
  final attributeController = Get.put(AttributeController());
  final RxList<ProductAttributeModel> productAttributes = <ProductAttributeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllAttributes();
  }

  // Method to toggle the selection of attribute values
  void toggleAttributeValue(String value) {
    if (selectedAttributeValues.contains(value)) {
      selectedAttributeValues.remove(value);
    } else {
      selectedAttributeValues.add(value);
    }

    print(selectedAttributeValues);
  }

  Future<void> fetchAllAttributes() async {
    try {
      isLoading.value = true;
      await attributeController.fetchItems();
    } catch (e) {
      TNotificationOverlay.warning(context: Get.context!, title: TTexts.ohSnap.tr, subTitle: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Function to add a new attribute
  void addNewAttribute() {
    // Add a new attribute to productAttributes by cloning the selectedAttributeValues
    productAttributes.add(
      ProductAttributeModel(
        id: '',
        attributeId: selectedAttribute.value.id,
        name: selectedAttribute.value.name,
        values: List<String>.from(selectedAttributeValues),
        isColorAttribute: selectedAttribute.value.isColorAttribute,
      ),
    );

    // Clear the selected values after adding the new attribute
    selectedAttributeValues.clear();
    selectedAttribute.value = AttributeModel.empty();
  }

  // Function to remove an attribute
  void removeAttribute(int index, BuildContext context) {
    // Show a confirmation dialog
    TDialogs.defaultDialog(
      context: context,
      onConfirm: () {
        // User confirmed, remove the attribute
        Navigator.of(context).pop();
        productAttributes.removeAt(index);

        // Reset productVariations when removing an attribute
        ProductVariationController.instance.productVariations.value = [];
      },
    );
  }

  // Function to reset productAttributes
  void resetProductAttributes() {
    productAttributes.clear();
  }
}
