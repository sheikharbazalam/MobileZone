import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../abstract/base_repository.dart';
import '../../services/notification/notification_model.dart';

class NotificationRepository extends TBaseRepositoryController<NotificationModel> {
  // Singleton instance of the NotificationRepository
  static NotificationRepository get instance => Get.find();

  @override
  Future<String> addItem(NotificationModel item) async {
    final result = await db.collection("Notifications").add(item.toJson());
    return result.id;
  }

  @override
  Future<List<NotificationModel>> fetchAllItems() async {
    final snapshot = await db.collection("Notifications").orderBy('createdAt', descending: true).get();
    final result = snapshot.docs.map((e) => NotificationModel.fromDocSnapshot(e)).toList();
    return result;
  }

  @override
  Future<NotificationModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("Notifications").doc(id).get();
    final result = NotificationModel.fromDocSnapshot(snapshot);
    return result;
  }

  @override
  NotificationModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return NotificationModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('Notifications').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(NotificationModel item) async {
    await db.collection("Notifications").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Notifications").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(NotificationModel item) async {
    await db.collection("Notifications").doc(item.id).delete();
  }
}
