import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/product_management/models/product_model.dart';
import '../../abstract/base_repository.dart';

class RecommendedProductsRepository extends TBaseRepositoryController<ProductModel> {
  // Singleton instance of the ProductRepository
  static RecommendedProductsRepository get instance => Get.find();

  @override
  Future<String> addItem(ProductModel item) async {
    final result = await db.collection("Products").add(item.toJson());
    return result.id;
  }

  @override
  Future<List<ProductModel>> fetchAllItems() async {
    final snapshot = await db
        .collection("Products")
        .where('isActive', isEqualTo: true)
        .where('isDraft', isEqualTo: false)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .get();
    final result = snapshot.docs.map((e) => ProductModel.fromDocSnapshot(e)).toList();
    return result;
  }

  @override
  Future<ProductModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("Products").doc(id).get();
    final result = ProductModel.fromDocSnapshot(snapshot);
    return result;
  }

  @override
  ProductModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return ProductModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db
      .collection('Products')
      .where('isActive', isEqualTo: true)
      .where('isDraft', isEqualTo: false)
      .where('isDeleted', isEqualTo: false)
      .orderBy('createdAt', descending: true)
      .limit(limit);

  @override
  Future<void> updateItem(ProductModel item) async {
    await db.collection("Products").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Products").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(ProductModel item) async {
    await db.collection("Products").doc(item.id).delete();
  }
}
