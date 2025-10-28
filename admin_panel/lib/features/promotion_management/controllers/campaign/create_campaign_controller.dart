import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/campaign/campaign_repository.dart';

import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../product_management/models/product_model.dart';
import '../../models/campaign_model.dart';
import '../campaign/campaign_controller.dart';

import 'package:t_utils/t_utils.dart';

class CreateCampaignController extends GetxController {
  static CreateCampaignController get instance => Get.find();

  final isLoading = false.obs;
  final isActive = true.obs;
  final isFeatured = true.obs;

  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();
  final startDateTextField = TextEditingController();
  final endDateTextField = TextEditingController();
  final discountValue = TextEditingController();
  final campaignType = CampaignType.product.obs;
  final discountType = DiscountType.percentage.obs;
  final startDate = DateTime.now().obs;
  final endDate = DateTime.now().obs;

  var selectedTypeIds = <String>[].obs;
  final selectedProducts = <ProductModel>[].obs;

  final campaignController = Get.put(CampaignController());
  final repository = Get.put(CampaignRepository());

  /// Register new Campaign
  Future<void> createCampaign() async {
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

      if (endDate.value.isBefore(startDate.value)) throw TTexts.chooseStartEndDatesProperly.tr;

      _setTargetScreen();

      // Map Data
      final newRecord = CampaignModel(
        id: '',
        title: title.text.trim(),
        description: description.text.trim(),
        discountValue: double.tryParse(discountValue.text.trim()) ?? 0.0,
        discountType: discountType.value,
        relatedIds: selectedTypeIds,
        type: campaignType.value,
        associatedBanners: [],
        clickCount: 0,
        isActive: isActive.value,
        isFeatured: isFeatured.value,
        startDate: startDateTextField.text.trim().isEmpty ? null : startDate.value,
        endDate: startDateTextField.text.trim().isEmpty
            ? null
            : endDateTextField.text.trim().isEmpty
                ? null
                : endDate.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Call Repository to Create New Campaign
      newRecord.id = await repository.addNewItem(newRecord);

      // Update All Data list
      campaignController.insertItemAtStartInLists(newRecord);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Return
      Get.back();

      // Success Message & Redirect
      TLoaders.successSnackBar(title: TTexts.ohSnap.tr, message: 'New Record has been added.');
    } catch (e) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title:TTexts.ohSnap.tr, message: e.toString());
    }
  }

  void _setTargetScreen() {
    if (campaignType.value == CampaignType.product) {
      if (selectedProducts.isEmpty) throw TTexts.selectProductsAsCampaignTarget.tr;
      selectedTypeIds.value = selectedProducts.map((product) => product.id).toList();
    }
  }

  /// Method to reset fields
  void resetFields() {
    title.clear();
    description.clear();
    campaignType.value = CampaignType.product;
    startDateTextField.clear();
    endDateTextField.clear();
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
    isLoading(false);
    isActive.value = true;
    discountValue.clear();
    selectedTypeIds.value = [];
    selectedProducts.value = [];
  }
}
