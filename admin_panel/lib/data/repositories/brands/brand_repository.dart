import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/data_management/models/brand_model.dart';
import '../../abstract/base_repository.dart';

class BrandRepository extends TBaseRepositoryController<BrandModel> {
  // Singleton instance of the BrandRepository
  static BrandRepository get instance => Get.find();

  @override
  Future<String> addItem(BrandModel item) async {
    final result = await db.collection("Brands").add(item.toJson());
    return result.id;
  }

  @override
  Future<List<BrandModel>> fetchAllItems() async {
    final snapshot = await db.collection("Brands").orderBy('createdAt', descending: true).get();
    final result = snapshot.docs.map((e) => BrandModel.fromDocSnapshot(e)).toList();
    return result;
  }

  @override
  Future<BrandModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("Brands").doc(id).get();
    final result = BrandModel.fromDocSnapshot(snapshot);
    return result;
  }

  @override
  BrandModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return BrandModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('Brands').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(BrandModel item) async {
    await db.collection("Brands").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Brands").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(BrandModel item) async {
    await db.collection("Brands").doc(item.id).delete();
  }
}
