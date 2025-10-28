import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../data/repositories/attributes/attributes_repository.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../models/attribute_model.dart';
import 'attribute_controller.dart';

class EditAttributeController extends GetxController {
  static EditAttributeController get instance => Get.find();

  // Inject the repository
  final AttributeRepository attributeRepository = Get.put(AttributeRepository());
  final attributeController = Get.put(AttributeController());

  final isLoading = false.obs;
  final isSearchable = true.obs;
  final isFilterable = true.obs;
  final isActive = false.obs;

  final isColorAttribute = false.obs;
  final selectedColors = <Color>[].obs;
  final pickerColor = TColors().primary.obs;

  final name = TextEditingController();
  final attributeValues = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final attribute = AttributeModel.empty().obs;
  final attributeId = ''.obs;

  /// Init Data
  Future<void> init() async {
    try {
      // Fetch record if argument was null
      if (attribute.value.id.isEmpty) {
        isLoading.value = true;
        attribute.value = await attributeRepository.getSingleItem(attributeId.value);
      }

      name.text = attribute.value.name;
      isActive.value = attribute.value.isActive;
      isSearchable.value = attribute.value.isSearchable;
      isFilterable.value = attribute.value.isFilterable;
      isColorAttribute.value = attribute.value.isColorAttribute;

      if (!isColorAttribute.value) attributeValues.text = attribute.value.attributeValues.map((v) => v).join(' | ');
      if (isColorAttribute.value) selectedColors.assignAll(convertStringsToColors(attribute.value.attributeValues));
    } catch (e) {
      if (kDebugMode) printError(info: e.toString());
      TNotificationOverlay.error(context: Get.context!, title: 'Oh Snap', subTitle: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Register new Attribute
  Future<void> updateAttribute(AttributeModel attribute) async {
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
      attribute.name = name.text.trim();
      attribute.isActive = isActive.value;
      attribute.updatedAt = DateTime.now();
      attribute.isSearchable = isSearchable.value;
      attribute.isFilterable = isFilterable.value;
      attribute.attributeValues = attributeValuesNames;
      attribute.isColorAttribute = isColorAttribute.value;

      // Call Repository to Create New User
      await AttributeRepository.instance.updateItemRecord(attribute);

      // Update All Data list
      AttributeController.instance.updateItemFromLists(attribute);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Success Message & Redirect
      TNotificationOverlay.success(context: Get.context!, title: TTexts.attributeUpdated.tr, duration: Duration(seconds: 3));

      // Return
      Get.back();
    } catch (e) {
      isLoading.value = false;
      TNotificationOverlay.error(context: Get.context!, title:  TTexts.ohSnap.tr, subTitle: e.toString());
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
    attributeValues.clear();
  }
}
