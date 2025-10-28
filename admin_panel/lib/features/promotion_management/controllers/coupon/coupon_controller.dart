import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/coupon/coupons_repository.dart';
import '../../models/coupon_model.dart';

class CouponController extends TBaseTableController<CouponModel> {
  static CouponController get instance => Get.find();

  // Inject the repository
  final CouponRepository couponRepository = Get.put(CouponRepository());

  @override
  Future<List<CouponModel>> fetchItems() async {
    // To make sure add more items button is not visible (allFetchedItems < limit)
    limit.value = 10000000;
    return await couponRepository.getAllItems();
  }

  @override
  bool containsSearchQuery(CouponModel item, String query) {
    return item.code.toLowerCase().contains(query.toLowerCase());
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (CouponModel category) => category.code.toLowerCase());
  }

  @override
  Future<CouponModel?> updateStatusToggleSwitch(bool toggle, CouponModel item) async {
    if (item.isActive == toggle) return null;

    item.isActive = toggle;
    await couponRepository.updateSingleItemRecord(item.id, {'isActive': toggle});
    return item;
  }

  @override
  Future<CouponModel?> updateFeaturedToggleSwitch(bool toggle, CouponModel item) async {
    await couponRepository.updateSingleItemRecord(item.id, {'isFeatured': toggle});
    return item;
  }

  @override
  Future<void> deleteItem(CouponModel item) async {
    // Now, delete the brand itself
    await CouponRepository.instance.deleteItemRecord(item);
  }
}
