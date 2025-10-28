import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:t_utils/t_utils.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/user/user_repository.dart';



import '../../../utils/constants/text_strings.dart';
import '../../media/controllers/media_controller.dart';
import '../../media/models/image_model.dart';
import '../models/user_model.dart';

/// Controller for managing admin-related data and operations
class UserController extends GetxController {
  static UserController get instance => Get.find();

  // Observable variables
  RxBool loading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // Dependencies
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    // Fetch user details on controller initialization
    fetchUserDetails();
    super.onInit();
  }

  /// Fetches user details from the repository
  Future<UserModel> fetchUserDetails() async {
    try {
      loading.value = true;
      if (user.value.id.isEmpty) {
        final user = await userRepository.getSingleItem(AuthenticationRepository.instance.authUser?.uid ?? '');
        this.user.value = user;
      }

      firstNameController.text = user.value.firstName;
      lastNameController.text = user.value.lastName;
      emailController.text = user.value.email;
      phoneController.text = user.value.phoneNumber;


      loading.value = false;
      return user.value;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: TTexts.somethingWentWrong.tr, message: e.toString());
      return UserModel.empty();
    }
  }

  /// Pick Thumbnail Image from Media
  void updateProfilePicture() async {
    try {
      loading.value = true;
      final controller = Get.put(MediaController());
      List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

      // Handle the selected images
      if (selectedImages != null && selectedImages.isNotEmpty) {
        // Set the selected image to the main image or perform any other action
        ImageModel selectedImage = selectedImages.first;

        // Update the main image using the selectedImage
        user.value.profilePicture = selectedImage.url;
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: e.toString());
    }
  }

  void updateUserInformation() async {
    try {
      loading.value = true;
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        loading.value = false;
        return;
      }
      user.value.firstName = firstNameController.text.trim();
      user.value.lastName = lastNameController.text.trim();
      user.value.phoneNumber = phoneController.text.trim();

      await userRepository.updateItemRecord(user.value);
      user.refresh();

      loading.value = false;
      TLoaders.successSnackBar(title:TTexts.congratulations.tr, message: TTexts.yourProfileUpdated.tr);
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: e.toString());
    }
  }
}
