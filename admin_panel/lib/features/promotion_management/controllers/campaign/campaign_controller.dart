import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/campaign/campaign_repository.dart';
import '../../models/campaign_model.dart';

class CampaignController extends TBaseTableController<CampaignModel> {
  static CampaignController get instance => Get.find();

  // Inject the repository
  final CampaignRepository campaignRepository = Get.put(CampaignRepository());

  @override
  Future<List<CampaignModel>> fetchItems() async {
    // To make sure add more items button is not visible (allFetchedItems < limit)
    limit.value = 10000000;
    return await campaignRepository.getAllItems();
  }

  @override
  bool containsSearchQuery(CampaignModel item, String query) {
    return item.title.toLowerCase().contains(query.toLowerCase());
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (CampaignModel category) => category.title.toLowerCase());
  }

  @override
  Future<CampaignModel?> updateStatusToggleSwitch(bool toggle, CampaignModel item) async {
    if (item.isActive == toggle) return null;

    item.isActive = toggle;
    await campaignRepository.updateSingleItemRecord(item.id, {'isActive': toggle});
    return item;
  }

  @override
  Future<CampaignModel?> updateFeaturedToggleSwitch(bool toggle, CampaignModel item) async {
    await campaignRepository.updateSingleItemRecord(item.id, {'isFeatured': toggle});
    return item;
  }

  @override
  Future<void> deleteItem(CampaignModel item) async {
    // Now, delete the brand itself
    await CampaignRepository.instance.deleteItemRecord(item);
  }
}
