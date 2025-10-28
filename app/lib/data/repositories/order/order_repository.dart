import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:t_utils/utils/constants/enums.dart';

import '../../../features/shop/models/order_model.dart';
import '../../../utils/constants/text_strings.dart';
import '../../abstract/base_repository.dart';
import '../authentication/authentication_repository.dart';

class OrderRepository extends TBaseRepositoryController<OrderModel> {
  static OrderRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;

  /* ---------------------------- FUNCTIONS ---------------------------------*/


  @override
  Future<String> addItem(OrderModel item) async {
    final doc = _db.collection('Orders');
    final ref = await doc.add(item.toJson());

    item.docId = ref.id;
    return item.docId;
  }


  @override
  Future<List<OrderModel>> fetchAllItems() async {
    final userId = AuthenticationRepository.instance.getUserID;
    if (userId.isEmpty) throw TTexts.unableUserInformation.tr;

    // Sub Collection Order -> Replaced with main Collection
    // final result = await _db.collection('Users').doc(userId).collection('Orders').get();
    final result = await _db.collection('Orders').where('userId', isEqualTo: userId).orderBy('updatedAt', descending: true).get();
    return result.docs.map((documentSnapshot) => OrderModel.fromDocSnapshot(documentSnapshot)).toList();
  }

  @override
  Future<OrderModel> fetchSingleItem(String id) async {
    final result = await _db.collection('Orders').doc(id).get();
    return OrderModel.fromJson(result.id, result.data()!);
  }

  @override
  OrderModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return OrderModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('Orders').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(OrderModel item) async {
    await db.collection("Orders").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Orders").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(OrderModel item) async {
    await db.collection("Orders").doc(item.id).delete();
  }


  /// Cancel Order
  Future<void> cancelOrder(OrderModel order) async {
    try {
      await _db.collection('Orders').doc(order.docId).update({
        'orderStatus': OrderStatus.canceled.name,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw TTexts.somethingWrongOrderInfo.tr;
    }
  }
}
