import 'dart:ui';

import 'package:t_utils/t_utils.dart';
import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/attributes/attributes_repository.dart';
import '../../models/attribute_model.dart';

class AttributeController extends TBaseTableController<AttributeModel> {
  static AttributeController get instance => Get.find();

  // Inject the repository
  final AttributeRepository attributeRepository = Get.put(AttributeRepository());

  @override
  Future<List<AttributeModel>> fetchItems() async {
    // To make sure add more items button is not visible (allFetchedItems < limit)
    limit.value = 10000000;
    return await attributeRepository.getAllItems();
  }

  @override
  bool containsSearchQuery(AttributeModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (AttributeModel category) => category.name.toLowerCase());
  }

  @override
  Future<AttributeModel?> updateStatusToggleSwitch(bool toggle, AttributeModel item) async {
    if (item.isActive == toggle) return null;

    item.isActive = toggle;
    await attributeRepository.updateSingleItemRecord(item.id, {'isActive': toggle});
    return item;
  }

  @override
  Future<AttributeModel?> updateFeaturedToggleSwitch(bool toggle, AttributeModel item) async {
    await attributeRepository.updateSingleItemRecord(item.id, {'isFeatured': toggle});
    return item;
  }

  @override
  Future<void> deleteItem(AttributeModel item) async {
    // Now, delete the brand itself
    await AttributeRepository.instance.deleteItemRecord(item);
  }

  /// Convert a list of Colors to their string representations
  List<String> convertColorsToStrings(List<Color> colors) {
    return colors.map((color) => THelperFunctions.computeColorValue(color).toString()).toList();
  }

  /// Convert a list of color strings back to Color objects
  List<Color> convertStringsToColors(List<String> colorStrings) {
    return colorStrings.map((colorString) => THelperFunctions.restoreColorFromValue(colorString)).toList();
  }
}
