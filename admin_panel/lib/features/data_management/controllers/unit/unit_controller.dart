import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/units/units_repository.dart';
import '../../models/unit_model.dart';

class UnitController extends TBaseTableController<UnitModel> {
  static UnitController get instance => Get.find();

  // Inject the repository
  final UnitRepository unitRepository = Get.put(UnitRepository());

  @override
  Future<List<UnitModel>> fetchItems() async {
    // To make sure add more items button is not visible (allFetchedItems < limit)
    limit.value = 10000000;
    return await unitRepository.getAllItems();
  }

  @override
  bool containsSearchQuery(UnitModel item, String query) {
    return item.unitName.toLowerCase().contains(query.toLowerCase());
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (UnitModel category) => category.unitName.toLowerCase());
  }

  @override
  Future<UnitModel?> updateStatusToggleSwitch(bool toggle, UnitModel item) async {
    if (item.isActive == toggle) return null;

    item.isActive = toggle;
    await unitRepository.updateSingleItemRecord(item.id, {'isActive': toggle});
    return item;
  }

  @override
  Future<UnitModel?> updateFeaturedToggleSwitch(bool toggle, UnitModel item) async {
    await unitRepository.updateSingleItemRecord(item.id, {'isFeatured': toggle});
    return item;
  }

  @override
  Future<void> deleteItem(UnitModel item) async {
    // Now, delete the brand itself
    await UnitRepository.instance.deleteItemRecord(item);
  }
}
