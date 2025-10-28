import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../features/role_management/models/role_model.dart';
import '../../abstract/base_repository.dart';

/// Repository class for vehicle-related operations.
class RoleRepository extends TBaseRepositoryController<RoleModel> {
  static RoleRepository get instance => Get.find();

  @override
  Future<String> addItem(RoleModel item) async {
    final result = await db.collection('Roles').add(item.toJson());
    return result.id;
  }

  @override
  Future<void> deleteItem(RoleModel item) async {
    await db.collection("Roles").doc(item.id).delete();
  }

  @override
  Future<List<RoleModel>> fetchAllItems() async {
    final documentSnapshot = await db.collection("Roles").get();
    final roles = documentSnapshot.docs.map((vt) => RoleModel.fromDocumentSnapshot(vt)).toList();
    return roles;
  }

  @override
  Future<RoleModel> fetchSingleItem(String id) async {
    final documentSnapshot = await db.collection("Roles").doc(id).get();
    if (documentSnapshot.exists) {
      return RoleModel.fromDocumentSnapshot(documentSnapshot);
    } else {
      return RoleModel.empty;
    }
  }

  @override
  Future<void> updateItem(RoleModel item) async {
    await db.collection("Roles").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Roles").doc(id).update(json);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('Roles').orderBy('createdAt', descending: true).limit(limit);

  @override
  RoleModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return RoleModel.empty;
  }

  @override
  Query<Map<String, dynamic>> getFilteredPaginatedQuery({required int limit, Map<String, dynamic>? isEqualTo, Map<String, dynamic>? isNotEqualTo, Map<String, Iterable<Object?>?>? arrayContainsAny, Map<String, Iterable<Object?>?>? whereIn, Map<String, bool>? isNull}) {
    // TODO: implement getFilteredPaginatedQuery
    throw UnimplementedError();
  }


}
