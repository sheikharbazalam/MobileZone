import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/product_management/models/order_model.dart';
import '../../abstract/base_repository.dart';

class OrderRepository extends TBaseRepositoryController<OrderModel> {
  // Singleton instance of the OrderRepository
  static OrderRepository get instance => Get.find();

  @override
  Future<String> addItem(OrderModel item) async {
    final result = await db.collection("Orders").add(item.toJson());
    return result.id;
  }

  @override
  Future<List<OrderModel>> fetchAllItems() async {
    final snapshot = await db.collection("Orders").orderBy('createdAt', descending: true).get();
    final result = snapshot.docs.map((e) => OrderModel.fromDocSnapshot(e)).toList();
    return result;
  }

  @override
  Future<OrderModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("Orders").doc(id).get();
    final result = OrderModel.fromDocSnapshot(snapshot);
    return result;
  }

  @override
  OrderModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return OrderModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('Orders').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(OrderModel item) async {
    await db.collection("Orders").doc(item.docId).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Orders").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(OrderModel item) async {
    await db.collection("Orders").doc(item.docId).delete();

    final batch = db.batch();

    // Reference to the Retailer document
    DocumentReference userRef = db.collection("Users").doc(item.userId);

    // Prepare to update the user stats
    batch.set(
      userRef,
      {
        'orderCount': FieldValue.increment(-1),
        'points': FieldValue.increment(-item.pointsUsed),
      },
      SetOptions(merge: true),
    );

    // Finally, delete the order
    await db.collection("Orders").doc(item.id).delete();

    // Commit the batch
    await batch.commit();
  }
}
