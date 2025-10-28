import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/data_management/models/unit_model.dart';
import '../../abstract/base_repository.dart';

class UnitRepository extends TBaseRepositoryController<UnitModel> {
  static UnitRepository get instance => Get.find();

  @override
  Future<String> addItem(UnitModel item) async {
    final result = await db.collection("Units").add(item.toJson());
    return result.id;
  }

  @override
  Future<List<UnitModel>> fetchAllItems() async {
    final snapshot = await db.collection("Units").orderBy('createdAt', descending: true).get();
    final result = snapshot.docs.map((e) => UnitModel.fromDocSnapshot(e)).toList();
    return result;
  }

  @override
  Future<UnitModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("Units").doc(id).get();
    final result = UnitModel.fromDocSnapshot(snapshot);
    return result;
  }

  @override
  UnitModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return UnitModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('Units').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(UnitModel item) async {
    await db.collection("Units").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Units").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(UnitModel item) async {
    await db.collection("Units").doc(item.id).delete();
  }
}
