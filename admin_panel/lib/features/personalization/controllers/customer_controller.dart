import 'package:get/get.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../data/abstract/base_data_table_controller.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../models/user_model.dart';

class CustomerController extends TBaseTableController<UserModel> {
  static CustomerController get instance => Get.find();

  final _customerRepository = Get.put(UserRepository());

  @override
  Future<List<UserModel>> fetchItems() async {
    return await _customerRepository.fetchPaginatedItems(limit.value);
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
    await _customerRepository.deleteItemRecord(item);
  }

  @override
  Future<UserModel?> updateFeaturedToggleSwitch(bool toggle, UserModel item) async {
    return item;
  }

  @override
  Future<UserModel?> updateStatusToggleSwitch(bool toggle, UserModel item) async {
    return item;
  }
}
