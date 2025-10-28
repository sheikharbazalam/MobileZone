import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/dashboard/models/order_stats_model.dart';
import '../../abstract/base_repository.dart';

class OrderStatsRepository extends TBaseRepositoryController<OrderStatsModel> {
  // Singleton instance of the OrderStatsRepository
  static OrderStatsRepository get instance => Get.find();

  @override
  Future<String> addItem(OrderStatsModel item) async {
    final result = await db.collection("StatsOrders").add(item.toJson());
    return result.id;
  }

  @override
  Future<List<OrderStatsModel>> fetchAllItems() async {
    final snapshot = await db.collection("StatsOrders").orderBy('createdAt', descending: true).get();
    final result = snapshot.docs.map((e) => OrderStatsModel.fromDocSnapshot(e)).toList();
    return result;
  }

  @override
  Future<OrderStatsModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("StatsOrders").doc(id).get();
    if (snapshot.exists) {
      final result = OrderStatsModel.fromDocSnapshot(snapshot);
      return result;
    } else {
      return OrderStatsModel.empty();
    }
  }

  @override
  OrderStatsModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return OrderStatsModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('StatsOrders').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(OrderStatsModel item) async {
    await db.collection("StatsOrders").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("StatsOrders").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(OrderStatsModel item) async {
    await db.collection("StatsOrders").doc(item.id).delete();
  }
}
