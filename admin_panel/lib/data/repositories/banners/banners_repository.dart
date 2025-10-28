import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/promotion_management/models/banner_model.dart';
import '../../abstract/base_repository.dart';

class BannerRepository extends TBaseRepositoryController<BannerModel> {
  // Singleton instance of the BannerRepository
  static BannerRepository get instance => Get.find();

  @override
  Future<String> addItem(BannerModel item) async {
    final result = await db.collection("Banners").add(item.toJson());
    return result.id;
  }

  @override
  Future<List<BannerModel>> fetchAllItems() async {
    final snapshot = await db.collection("Banners").orderBy('createdAt', descending: true).get();
    final result = snapshot.docs.map((e) => BannerModel.fromDocSnapshot(e)).toList();
    return result;
  }

  @override
  Future<BannerModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("Banners").doc(id).get();
    final result = BannerModel.fromDocSnapshot(snapshot);
    return result;
  }

  @override
  BannerModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return BannerModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('Banners').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(BannerModel item) async {
    await db.collection("Banners").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Banners").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(BannerModel item) async {
    await db.collection("Banners").doc(item.id).delete();
  }
}
