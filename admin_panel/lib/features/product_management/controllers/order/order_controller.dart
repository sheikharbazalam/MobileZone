import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/order/orders_repository.dart';
import '../../models/order_model.dart';

class OrderController extends TBaseTableController<OrderModel> {
  static OrderController get instance => Get.find();

  // Inject the repository
  final OrderRepository orderRepository = Get.put(OrderRepository());

  @override
  Future<List<OrderModel>> fetchItems() async {
    return await orderRepository.fetchPaginatedItems(10);
  }

  @override
  bool containsSearchQuery(OrderModel item, String query) {
    return item.id.toLowerCase().contains(query.toLowerCase());
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (OrderModel category) => category.id.toLowerCase());
  }
  void sortById(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (OrderModel o) => o.totalAmount.toString().toLowerCase());
  }

  @override
  Future<OrderModel?> updateStatusToggleSwitch(bool toggle, OrderModel item) async {
    return item;
  }

  @override
  Future<OrderModel?> updateFeaturedToggleSwitch(bool toggle, OrderModel item) async {
    return item;
  }

  @override
  Future<void> deleteItem(OrderModel item) async {
    // Now, delete the brand itself
    await OrderRepository.instance.deleteItemRecord(item);
  }
}
