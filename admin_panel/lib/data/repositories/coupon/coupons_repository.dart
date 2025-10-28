import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/promotion_management/models/coupon_model.dart';
import '../../abstract/base_repository.dart';

class CouponRepository extends TBaseRepositoryController<CouponModel> {
  // Singleton instance of the CouponRepository
  static CouponRepository get instance => Get.find();

  @override
  Future<String> addItem(CouponModel item) async {
    final result = await db.collection("Coupons").add(item.toJson());
    return result.id;
  }

  @override
  Future<List<CouponModel>> fetchAllItems() async {
    final snapshot = await db.collection("Coupons").orderBy('createdAt', descending: true).get();
    final result = snapshot.docs.map((e) => CouponModel.fromDocSnapshot(e)).toList();
    return result;
  }

  @override
  Future<CouponModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("Coupons").doc(id).get();
    final result = CouponModel.fromDocSnapshot(snapshot);
    return result;
  }

  @override
  CouponModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return CouponModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('Coupons').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(CouponModel item) async {
    await db.collection("Coupons").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Coupons").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(CouponModel item) async {
    await db.collection("Coupons").doc(item.id).delete();
  }
}
