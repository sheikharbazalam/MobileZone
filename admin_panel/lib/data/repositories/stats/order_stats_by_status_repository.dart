import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/dashboard/models/order_stats_by_status_model.dart.dart';
import '../../abstract/base_repository.dart';

class OrderStatsByStatusRepository extends TBaseRepositoryController<OrderStatsByStatusModel> {
  // Singleton instance of the OrderStatsRepository
  static OrderStatsByStatusRepository get instance => Get.find();

  @override
  Future<String> addItem(OrderStatsByStatusModel item) async {
    final result = await db.collection("StatsOrderByStatus").add(item.toJson());
    return result.id;
  }

  @override
  Future<List<OrderStatsByStatusModel>> fetchAllItems() async {
    final snapshot = await db.collection("StatsOrderByStatus").get();
    final result = snapshot.docs.map((e) => OrderStatsByStatusModel.fromDocSnapshot(e)).toList();
    return result;
  }

  @override
  Future<OrderStatsByStatusModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("StatsOrderByStatus").doc(id).get();
    if(snapshot.exists){
      final result = OrderStatsByStatusModel.fromDocSnapshot(snapshot);
      return result;
    }else{
      return OrderStatsByStatusModel.empty();
    }
  }

  @override
  OrderStatsByStatusModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return OrderStatsByStatusModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('StatsOrderByStatus').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(OrderStatsByStatusModel item) async {
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
  }

  @override
  Future<void> deleteItem(OrderStatsByStatusModel item) async {
  }
}
