import 'package:cwt_ecommerce_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:cwt_ecommerce_admin_panel/features/personalization/models/user_model.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';


import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/user/user_repository.dart';


/// Controller for managing admin-related data and operations
class AdminController extends TBaseTableController<UserModel> {
  static AdminController get instance => Get.find();

  // Observable variables
  RxBool loading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final Rx<AppRole> role = AppRole.user.obs;

  final profileFormKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

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
        final user = await userRepository.fetchSingleItem(AuthenticationRepository.instance.authUser?.uid ?? '');
        this.user.value = user;
      }

      fullNameController.text = user.value.fullName;
      phoneController.text = user.value.phoneNumber;
      emailController.text = user.value.email;

      loading.value = false;
      return user.value;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return UserModel.empty();
    }
  }


  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (UserModel o) => o.fullName.toString().toLowerCase());
  }


  @override
  bool containsSearchQuery(UserModel item, String query) {
    return item.fullName.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(UserModel item) async {
    await AuthenticationRepository.instance.deleteUser(item.email);
    await userRepository.deleteItem(item);
  }

  @override
  Future<List<UserModel>> fetchItems() async {
    return await userRepository.fetchFilteredPaginatedItems(isNotEqualTo: {'role' : role.value.name}, limit: limit.value,);
  }

  @override
  Future<UserModel?> updateStatusToggleSwitch(bool toggle, UserModel item) async {
    if (item.isProfileActive == toggle) return null;

    item.isProfileActive = toggle;
    await userRepository.updateSingleField(item.id, {'isProfileActive': toggle});
    return item;
  }

  @override
  Future<UserModel?> updateFeaturedToggleSwitch(bool toggle, UserModel item) async {
    return item;
  }



}
