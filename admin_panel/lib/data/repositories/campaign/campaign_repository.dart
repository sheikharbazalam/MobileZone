import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/promotion_management/models/campaign_model.dart';
import '../../abstract/base_repository.dart';

class CampaignRepository extends TBaseRepositoryController<CampaignModel> {
  // Singleton instance of the CampaignRepository
  static CampaignRepository get instance => Get.find();

  @override
  Future<String> addItem(CampaignModel item) async {
    final result = await db.collection("Campaigns").add(item.toJson());
    return result.id;
  }

  @override
  Future<List<CampaignModel>> fetchAllItems() async {
    final snapshot = await db.collection("Campaigns").orderBy('createdAt', descending: true).get();
    final result = snapshot.docs.map((e) => CampaignModel.fromDocSnapshot(e)).toList();
    return result;
  }

  @override
  Future<CampaignModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("Campaigns").doc(id).get();
    final result = CampaignModel.fromDocSnapshot(snapshot);
    return result;
  }

  @override
  CampaignModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return CampaignModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('Campaigns').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(CampaignModel item) async {
    await db.collection("Campaigns").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Campaigns").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(CampaignModel item) async {
    await db.collection("Campaigns").doc(item.id).delete();
  }
}
