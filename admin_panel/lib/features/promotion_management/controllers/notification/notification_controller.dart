import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/notification/notifications_repository.dart';
import '../../../../data/services/notification/notification_model.dart';

class NotificationController extends TBaseTableController<NotificationModel> {
  static NotificationController get instance => Get.find();

  // Inject the repository
  final NotificationRepository notificationRepository = Get.put(NotificationRepository());

  @override
  Future<List<NotificationModel>> fetchItems() async {
    // To make sure add more items button is not visible (allFetchedItems < limit)
    limit.value = 10000000;
    return await notificationRepository.getAllItems();
  }

  @override
  bool containsSearchQuery(NotificationModel item, String query) {
    return item.title.toLowerCase().contains(query.toLowerCase());
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (NotificationModel category) => category.title.toLowerCase());
  }

  @override
  Future<NotificationModel?> updateStatusToggleSwitch(bool toggle, NotificationModel item) async {
    return item;
  }

  @override
  Future<NotificationModel?> updateFeaturedToggleSwitch(bool toggle, NotificationModel item) async {
    await notificationRepository.updateSingleItemRecord(item.id, {'isFeatured': toggle});
    return item;
  }

  @override
  Future<void> deleteItem(NotificationModel item) async {
    // Now, delete the brand itself
    await NotificationRepository.instance.deleteItemRecord(item);
  }
}
