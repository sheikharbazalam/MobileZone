import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../data/repositories/attributes/attributes_repository.dart';

import '../../models/attribute_model.dart';
import 'attribute_controller.dart';

class CreateAttributeController extends GetxController {
  static CreateAttributeController get instance => Get.find();

  final isLoading = false.obs;
  final isActive = true.obs;
  final isSearchable = true.obs;
  final isFilterable = true.obs;

  final isColorAttribute = false.obs;
  final selectedColors = <Color>[].obs;
  final pickerColor = TColors().primary.obs;

  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final attributeValues = TextEditingController();
  final attributeController = Get.put(AttributeController());
  final repository = Get.put(AttributeRepository());

  /// Register new Attribute
  Future<void> createAttribute() async {
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

      // Determine attribute values
      final attributeValuesNames = isColorAttribute.value
          ? convertColorsToStrings() // Save color values as strings
          : attributeValues.text.trim().split('|').map((value) => value.trim()).toList();

      // Map Data
      final newRecord = AttributeModel(
        id: '',
        name: name.text.trim(),
        isActive: isActive.value,
        createdAt: DateTime.now(),
        isSearchable: isSearchable.value,
        isFilterable: isFilterable.value,
        attributeValues: attributeValuesNames,
        isColorAttribute: isColorAttribute.value,
      );

      // Call Repository to Create New Attribute
      newRecord.id = await repository.addNewItem(newRecord);

      // Update All Data list
      attributeController.insertItemAtStartInLists(newRecord);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Success Message & Redirect
      TNotificationOverlay.success(context: Get.context!, title: 'Attribute Created', duration: Duration(seconds: 3));

      // Return
      Get.back();
    } catch (e) {
      isLoading.value = false;
      TNotificationOverlay.error(context: Get.context!, title: 'Oh Snap', subTitle: e.toString());
    }
  }

  /// Add a color to the list
  void addColorToList() {
    if (!selectedColors.contains(pickerColor.value)) {
      selectedColors.add(pickerColor.value);
    }
  }

  /// Remove a color from the list
  void removeColorFromList(Color color) {
    selectedColors.remove(color);
  }

  /// Convert a list of Colors to their string representations
  List<String> convertColorsToStrings() {
    return selectedColors.map((color) => THelperFunctions.computeColorValue(color).toString()).toList();
  }

  /// Convert a list of color strings back to Color objects
  List<Color> convertStringsToColors(List<String> colorStrings) {
    return colorStrings.map((colorString) => THelperFunctions.restoreColorFromValue(colorString)).toList();
  }

  /// Method to reset fields
  void resetFields() {
    name.clear();
    isLoading(false);
    isFilterable(false);
    isSearchable(false);
    isActive.value = true;
    isColorAttribute.value = false;
    pickerColor.value = Colors.white;
    selectedColors.clear();
    attributeValues.clear();
  }
}
