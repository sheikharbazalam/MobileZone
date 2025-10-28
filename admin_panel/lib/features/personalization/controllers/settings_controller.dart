import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';

import '../../../data/repositories/setting/setting_repository.dart';
import '../../../utils/constants/text_strings.dart';
import '../../media/controllers/media_controller.dart';
import '../../media/models/image_model.dart';
import '../models/setting_model.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

// Observable variables
  RxBool loading = false.obs;
  final selectedImageURL = ''.obs;
  Rx<SettingsModel> settings = SettingsModel().obs;

  // New toggle state for Tax & Shipping Settings
  RxBool isTaxShippingEnabled = true.obs;
  RxBool isPointBaseEnabled = true.obs;

  final formKey = GlobalKey<FormState>();
  final TextEditingController appNameController = TextEditingController();

  //Tax & Shipping settings Text controllers to capture input values
  final TextEditingController taxController = TextEditingController();
  final TextEditingController shippingController = TextEditingController();
  final TextEditingController freeShippingThresholdController = TextEditingController();

  // Points-based system Text controllers to capture input values
  final TextEditingController pointsToDollarController = TextEditingController();
  final TextEditingController purchasePointsController = TextEditingController();
  final TextEditingController ratingPointsController = TextEditingController();
  final TextEditingController reviewPointsController = TextEditingController();

  // Dependencies
  final settingRepository = Get.put(SettingsRepository());

  @override
  void onInit() {
    // Fetch setting details on controller initialization
    fetchSettingDetails();
    super.onInit();
  }

  /// Fetches setting details from the repository and updates the UI
  Future<SettingsModel> fetchSettingDetails() async {
    try {
      loading.value = true;
      final settings = await settingRepository.getSettings();
      this.settings.value = settings;

      selectedImageURL.value = settings.appLogo;
      appNameController.text = settings.appName;
      taxController.text = settings.taxRate.toString();
      shippingController.text = settings.shippingCost.toString();

      pointsToDollarController.text = settings.pointsToDollarConversion.toString();
      purchasePointsController.text = settings.pointsPerPurchase.toString();
      ratingPointsController.text = settings.pointsPerRating.toString();
      reviewPointsController.text = settings.pointsPerReview.toString();

      // Ensure toggle values are also updated
      isTaxShippingEnabled.value = settings.isTaxShippingEnabled;
      isPointBaseEnabled.value = settings.isPointBaseEnabled;

      freeShippingThresholdController.text =
          settings.freeShippingThreshold == null ? '' : settings.freeShippingThreshold.toString();

      loading.value = false;

      return settings;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: TTexts.somethingWentWrong.tr, message: e.toString());
      return SettingsModel();
    }
  }

  /// Toggle Tax & Shipping Settings
  void toggleTaxShippingSettings(bool value) {
    isTaxShippingEnabled.value = value;
  }

  void togglePointBaseSettings(bool value) {
    isPointBaseEnabled.value = value;
  }

  /// Pick Thumbnail Image from Media
  void updateAppLogo() async {
    try {
      final controller = Get.put(MediaController());
      List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

      // Handle the selected images
      if (selectedImages != null && selectedImages.isNotEmpty) {
        // Set the selected image to the main image or perform any other action
        ImageModel selectedImage = selectedImages.first;
        selectedImageURL.value = selectedImage.url;
      }
    } catch (e) {
      TLoaders.errorSnackBar(title:  TTexts.ohSnap.tr, message: e.toString());
    }
  }

  /// update setting information
  void updateSettingInformation() async {
    try {
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      settings.value.appLogo = selectedImageURL.value;
      settings.value.appName = appNameController.text.trim();
      settings.value.taxRate = double.tryParse(taxController.text.trim()) ?? 0.0;
      settings.value.shippingCost = double.tryParse(shippingController.text.trim()) ?? 0.0;
      settings.value.freeShippingThreshold = double.tryParse(freeShippingThresholdController.text.trim()) ?? 0.0;

      settings.value.pointsToDollarConversion = double.tryParse(pointsToDollarController.text.trim()) ?? 0.0;
      settings.value.pointsPerPurchase = double.tryParse(purchasePointsController.text.trim()) ?? 0.0;
      settings.value.pointsPerRating = double.tryParse(ratingPointsController.text.trim()) ?? 0.0;
      settings.value.pointsPerReview = double.tryParse(reviewPointsController.text.trim()) ?? 0.0;

      //  Ensure isTaxShippingEnabled is also updated in Firebase
      settings.value.isTaxShippingEnabled = isTaxShippingEnabled.value;
      settings.value.isPointBaseEnabled = isPointBaseEnabled.value;

      await settingRepository.updateSettingDetails(settings.value);
      settings.refresh();

      loading.value = false;
      TLoaders.successSnackBar(title: TTexts.congratulations.tr, message: 'App Settings has been updated.');
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: e.toString());
    }
  }
}
