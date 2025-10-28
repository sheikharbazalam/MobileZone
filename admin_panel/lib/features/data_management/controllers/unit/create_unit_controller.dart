import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';

import '../../../../data/repositories/units/units_repository.dart';

import 'package:t_utils/t_utils.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../models/unit_model.dart';
import 'unit_controller.dart';

class CreateUnitController extends GetxController {
  static CreateUnitController get instance => Get.find();

  final isLoading = false.obs;
  final isActive = true.obs;
  final isBaseUnit = true.obs;
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final abbreviation = TextEditingController();
  final searchKeywords = TextEditingController();
  final conversionFactor = TextEditingController();
  var unitTypeTextField = TextEditingController();
  final selectedUnitType = UnitType.unitLess.obs;
  final unitController = Get.put(UnitController());
  final repository = Get.put(UnitRepository());

  /// Register new Unit
  Future<void> createUnit() async {
    try {
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        return;
      }

      // Start Loading
      isLoading.value = true;

      // Add Units to the List of Units
      final unitValuesNames = searchKeywords.text.trim().split('|').map((value) => value.trim()).toList();

      // Map Data
      final newRecord = UnitModel(
        id: '',
        unitName: name.text.trim(),
        conversionFactor: double.tryParse(conversionFactor.text.trim()) ?? 0,
        isActive: isActive.value,
        createdAt: DateTime.now(),
        unitType: selectedUnitType.value,
        isBaseUnit: isBaseUnit.value,
        abbreviation: abbreviation.text.trim(),
        searchKeywords: unitValuesNames,
      );

      // Call Repository to Create New Unit
      newRecord.id = await repository.addNewItem(newRecord);

      // Update All Data list
      unitController.insertItemAtStartInLists(newRecord);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Success Message & Redirect
      TNotificationOverlay.success(context: Get.context!, title: TTexts.unitCreated.tr, duration: Duration(seconds: 3));

      // Return
      Get.back();
    } catch (e) {
      isLoading.value = false;
      TNotificationOverlay.error(context: Get.context!, title: TTexts.ohSnap.tr, subTitle: e.toString());
    }
  }

  /// Method to reset fields
  void resetFields() {
    name.clear();
    isLoading(false);
    isBaseUnit(false);
    abbreviation.clear();
    isActive.value = true;
    searchKeywords.clear();
    conversionFactor.clear();
    selectedUnitType.value = UnitType.unitLess;
  }
}
