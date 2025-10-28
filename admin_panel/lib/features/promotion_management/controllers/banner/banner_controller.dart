import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/banners/banners_repository.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/banner_model.dart';

class BannerController extends TBaseTableController<BannerModel> {
  static BannerController get instance => Get.find();

  // Inject the repository
  final BannerRepository bannerRepository = Get.put(BannerRepository());

  @override
  Future<List<BannerModel>> fetchItems() async {
    // To make sure add more items button is not visible (allFetchedItems < limit)
    limit.value = 10000000;
    return await bannerRepository.getAllItems();
  }

  @override
  bool containsSearchQuery(BannerModel item, String query) {
    return item.title.toLowerCase().contains(query.toLowerCase());
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (BannerModel category) => category.title.toLowerCase());
  }

  @override
  Future<BannerModel?> updateStatusToggleSwitch(bool toggle, BannerModel item) async {
    if (item.isActive == toggle) return null;

    item.isActive = toggle;
    await bannerRepository.updateSingleItemRecord(item.id, {'isActive': toggle});
    return item;
  }

  @override
  Future<BannerModel?> updateFeaturedToggleSwitch(bool toggle, BannerModel item) async {
    await bannerRepository.updateSingleItemRecord(item.id, {'isFeatured': toggle});
    return item;
  }

  @override
  Future<void> deleteItem(BannerModel item) async {
    // Now, delete the brand itself
    await BannerRepository.instance.deleteItemRecord(item);
  }

  // Method to handle navigation when a banner is clicked
  void onBannerClick(BannerModel banner) {
    switch (banner.targetType) {
      case BannerTargetType.productScreen:
        // Navigate to ProductScreen with the target product ID
        if (banner.targetId != null) {
          Get.toNamed(TRoutes.editProduct, arguments: {'id': banner.targetId});
        }
        break;

      case BannerTargetType.categoryScreen:
        // Navigate to CategoryScreen with the target category ID
        if (banner.targetId != null) {
          Get.toNamed(TRoutes.editCategory, arguments: {'id': banner.targetId});
        }
        break;

      case BannerTargetType.customUrl:
        // Open the custom URL in a web view or browser
        if (banner.customUrl != null) {
          Get.toNamed('/webview', arguments: {'url': banner.customUrl});
        }
        break;
      case BannerTargetType.brandScreen:
        // Navigate to CampaignScreen with the target campaign ID
        if (banner.targetId != null) {
          Get.toNamed(TRoutes.editBrand, arguments: {'id': banner.targetId});
        }
        break;

      case BannerTargetType.homeScreen:
        Get.toNamed(AppRoutes.home);
        break;
      case BannerTargetType.shopScreen:
        Get.toNamed(AppRoutes.shop);
        break;
      case BannerTargetType.settingScreen:
        Get.toNamed(AppRoutes.profile);
        break;
      case BannerTargetType.favouriteScreen:
        Get.toNamed(AppRoutes.favourite);
        break;
      case BannerTargetType.cart:
        Get.toNamed(AppRoutes.cart);
        break;
      case BannerTargetType.orders:
        Get.toNamed(AppRoutes.order);
        break;
      case BannerTargetType.profile:
        Get.toNamed(AppRoutes.profile);
        break;
      case BannerTargetType.none:
        break;
    }
  }
}
