import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/data_management/models/attribute_model.dart';
import '../../abstract/base_repository.dart';

class AttributeRepository extends TBaseRepositoryController<AttributeModel> {
  // Singleton instance of the AttributeRepository
  static AttributeRepository get instance => Get.find();

  @override
  Future<String> addItem(AttributeModel item) async {
    final result = await db.collection("Attributes").add(item.toJson());
    return result.id;
  }

  @override
  Future<List<AttributeModel>> fetchAllItems() async {
    final snapshot = await db.collection("Attributes").orderBy('createdAt', descending: true).get();
    final result = snapshot.docs.map((e) => AttributeModel.fromDocSnapshot(e)).toList();
    return result;
  }

  @override
  Future<AttributeModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("Attributes").doc(id).get();
    final result = AttributeModel.fromDocSnapshot(snapshot);
    return result;
  }

  @override
  AttributeModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return AttributeModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('Attributes').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(AttributeModel item) async {
    await db.collection("Attributes").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Attributes").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(AttributeModel item) async {
    await db.collection("Attributes").doc(item.id).delete();
  }
}
