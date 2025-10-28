import 'package:cwt_ecommerce_admin_panel/features/personalization/controllers/user_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/personalization/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';
import '../../../../../utils/exports.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/user/user_repository.dart';
import 'admin_controller.dart';

class CreateAdminController extends GetxController {
  static CreateAdminController get instance => Get.find();

  // Inject the repository
  final UserRepository userRepository = Get.put(UserRepository());


  /// Variables
  RxBool isLoading = false.obs;
  RxBool canPop = false.obs;
  var selectedGender = ''.obs; // Observable variable for gender
  var phoneNumber = TextEditingController(); // Observable variable for phoneNumber
  final email = TextEditingController(); // Controller for email input
  final lastName = TextEditingController(); // Controller for first name input
  final firstName = TextEditingController(); // Controller for last name input
  final dateOfBirth = TextEditingController(); // Controller for date of birth input
  final hidePassword = true.obs;
  final userController = UserController.instance;
  final password = TextEditingController();
  var selectedRole = Rxn<AppRole>();


  final createCustomerFormKey = GlobalKey<FormState>();


  /// Register New Admin
  Future<void> createUser() async {
    try {
      isLoading.value = true; // Set loading state to true

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }

      // Form Validation
      if (!createCustomerFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }


      String? uid =  await AuthenticationRepository.instance.createUser(email.text.trim(),password.text.trim());

      if(uid != null)
        {
          await  AuthenticationRepository.instance.assignAdminRoleInAuthentication(email.text.trim());

           // Map Data
          final newAdmin = UserModel(
            id: uid,
            isProfileActive: true,
            isEmailVerified: false,
            email: email.text.trim(),
            role: selectedRole.value!,
            lastName: lastName.text.trim(),
            firstName: firstName.text.trim(),
            phoneNumber: phoneNumber.text.trim(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

         await userRepository.addItem(newAdmin);

          // Update Lists
          AdminController.instance.addItemToLists(newAdmin);

          //Stop Loading
          isLoading.value = false;

          // Reset Fields
          resetFields();
          // Return
          // Get.back();

          // Success Message & Redirect
          TLoaders.successSnackBar(title: 'Congratulations', message: 'Admin has been created.');
        }
      else{
        isLoading.value = false;
        return;
      }
    } catch (e) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
    }
  }

  resetFields() {
    firstName.text = '';
    lastName.text = '';
    phoneNumber.text = '';
    email.text = '';
    password.text = '';
  }



}
