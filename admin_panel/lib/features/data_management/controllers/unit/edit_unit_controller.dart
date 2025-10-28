import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';

import '../../../../data/repositories/units/units_repository.dart';

import 'package:t_utils/t_utils.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../models/unit_model.dart';
import '../unit/unit_controller.dart';

class EditUnitController extends GetxController {
  static EditUnitController get instance => Get.find();

  final isActive = true.obs;
  final isLoading = false.obs;
  final isBaseUnit = true.obs;
  final name = TextEditingController();
  var unitTypeTextField = TextEditingController();
  final selectedUnitType = UnitType.unitLess.obs;
  final formKey = GlobalKey<FormState>();
  final abbreviation = TextEditingController();
  final searchKeywords = TextEditingController();
  final unitRepository = Get.put(UnitRepository());
  final conversionFactor = TextEditingController();
  final unitController = Get.put(UnitController());

  final unit = UnitModel.empty().obs;
  final unitId = ''.obs;

  /// Init Data
  Future<void> init() async {
    try {
      // Fetch record if argument was null
      if (unit.value.id.isEmpty) {
        isLoading.value = true;
        unit.value = await unitRepository.getSingleItem(unitId.value);
      }

      name.text = unit.value.unitName;
      isActive.value = unit.value.isActive;
      isBaseUnit.value = unit.value.isBaseUnit;
      abbreviation.text = unit.value.abbreviation;
      selectedUnitType.value = unit.value.unitType;
      conversionFactor.text = unit.value.conversionFactor.toString();
      unitTypeTextField.text = unit.value.unitType.name.capitalize.toString();

      searchKeywords.text = unit.value.searchKeywords!.map((v) => v).join(' | ');
    } catch (e) {
      if (kDebugMode) printError(info: e.toString());
      TNotificationOverlay.error(context: Get.context!, title: TTexts.unitCreated.tr, subTitle: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Register new Unit
  Future<void> updateUnit(UnitModel unit) async {
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

      // Add Units to the List of Units
      final unitValuesNames = searchKeywords.text.trim().split('|').map((value) => value.trim()).toList();

      // Map Data
      unit.unitName = name.text.trim();
      unit.unitType = selectedUnitType.value;
      unit.isActive = isActive.value;
      unit.isBaseUnit = isBaseUnit.value;
      unit.updatedAt = DateTime.now();
      unit.searchKeywords = unitValuesNames;
      unit.abbreviation = abbreviation.text.trim();
      unit.conversionFactor = double.tryParse(conversionFactor.text.trim()) ?? 0.0;

      // Call Repository to Create New User
      await UnitRepository.instance.updateItemRecord(unit);

      // Update All Data list
      UnitController.instance.updateItemFromLists(unit);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Success Message & Redirect
      TNotificationOverlay.success(context: Get.context!, title: 'Unit Updated', duration: Duration(seconds: 3));

      // Return
      Get.back();
    } catch (e) {
      isLoading.value = false;
      TNotificationOverlay.error(context: Get.context!, title: 'Oh Snap', subTitle: e.toString());
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
