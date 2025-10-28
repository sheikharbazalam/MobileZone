import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/dashboard/models/retailer_stats_model.dart';
import '../../abstract/base_repository.dart';

class RetailerOrderStatsRepository extends TBaseRepositoryController<RetailerStatsModel> {
  // Singleton instance of the RetailerOrderStatsRepository
  static RetailerOrderStatsRepository get instance => Get.find();

  @override
  Future<String> addItem(RetailerStatsModel item) async {
    final result = await db.collection("StatsRetailers").add(item.toJson());
    return result.id;
  }

  @override
  Future<List<RetailerStatsModel>> fetchAllItems() async {
    final snapshot = await db.collection("StatsRetailers").orderBy('createdAt', descending: true).get();
    final result = snapshot.docs.map((e) => RetailerStatsModel.fromDocSnapshot(e)).toList();
    return result;
  }

  @override
  Future<RetailerStatsModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("StatsRetailers").doc(id).get();
    final result = RetailerStatsModel.fromDocSnapshot(snapshot);
    return result;
  }

  @override
  RetailerStatsModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return RetailerStatsModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('StatsRetailers').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(RetailerStatsModel item) async {
    await db.collection("StatsRetailers").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("StatsRetailers").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(RetailerStatsModel item) async {
    await db.collection("StatsRetailers").doc(item.id).delete();
  }
}
