import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/data_management/models/category_model.dart';
import '../../abstract/base_repository.dart';

class CategoryRepository extends TBaseRepositoryController<CategoryModel> {
  // Singleton instance of the CategoryRepository
  static CategoryRepository get instance => Get.find();

  @override
  Future<String> addItem(CategoryModel item) async {
    final result = await db.collection('Categories').add(item.toJson());
    return result.id;
  }

  @override
  Future<void> deleteItem(CategoryModel item) async {
    await db.collection("Categories").doc(item.id).delete();
  }

  @override
  Future<List<CategoryModel>> fetchAllItems() async {
    final documentSnapshot = await db.collection("Categories").orderBy('createdAt', descending: true).get();
    final category = documentSnapshot.docs.map((vt) => CategoryModel.fromDocSnapshot(vt)).toList();
    return category;
  }

  @override
  Future<CategoryModel> fetchSingleItem(String id) async {
    final documentSnapshot = await db.collection("Categories").doc(id).get();
    if (documentSnapshot.exists) {
      return CategoryModel.fromDocSnapshot(documentSnapshot);
    } else {
      return CategoryModel.empty();
    }
  }

  @override
  CategoryModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return CategoryModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('Categories').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(CategoryModel item) async {
    await db.collection("Categories").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Categories").doc(id).update(json);
  }

  Future<List<CategoryModel>> searchProducts(String query) async {
    final lowerQuery = query.toLowerCase();
    try {
      // Query by title
      QuerySnapshot titleQuery = await db
          .collection('Categories')
          .where('name', isGreaterThanOrEqualTo: lowerQuery)
          .where('name', isLessThanOrEqualTo: '$lowerQuery\uf8ff')
          .where('isActive', isEqualTo: true)
          .limit(5)
          .get();

      return titleQuery.docs.map((value) => CategoryModel.fromQuerySnapshot(value)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }
}
