import 'package:cloud_firestore/cloud_firestore.dart';

class OrderStatsByStatusModel {
  int pending;
  int processing;
  int shipped;
  int delivered;
  int canceled;
  int returned;
  int refunded;

  // Constructor
  OrderStatsByStatusModel({
    required this.pending,
    required this.processing,
    required this.shipped,
    required this.delivered,
    required this.canceled,
    required this.returned,
    required this.refunded,
  });

  // Factory method to create an empty instance
  static OrderStatsByStatusModel empty() => OrderStatsByStatusModel(
    pending: 0,
    processing: 0,
    shipped: 0,
    delivered: 0,
    canceled: 0,
    returned: 0,
    refunded: 0,
  );

  // Factory method to create from JSON
  factory OrderStatsByStatusModel.fromJson(String id, Map<String, dynamic> json) {
    return OrderStatsByStatusModel(
      pending: json.containsKey('pending') ? json['pending'] ?? 0 : 0,
      processing: json.containsKey('processing') ? json['processing'] ?? 0 : 0,
      shipped: json.containsKey('shipped') ? json['shipped'] ?? 0 : 0,
      delivered: json.containsKey('delivered') ? json['delivered'] ?? 0 : 0,
      canceled: json.containsKey('canceled') ? json['canceled'] ?? 0 : 0,
      returned: json.containsKey('returned') ? json['returned'] ?? 0 : 0,
      refunded: json.containsKey('refunded') ? json['refunded'] ?? 0 : 0,
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'pending': pending,
      'processing': processing,
      'shipped': shipped,
      'delivered': delivered,
      'canceled': canceled,
      'returned': returned,
      'refunded': refunded,
    };
  }

  // Factory method to create from Firestore document snapshot
  factory OrderStatsByStatusModel.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return OrderStatsByStatusModel.fromJson(doc.id, data);
  }

  // Factory method to create from QueryDocumentSnapshot (for multiple attributes)
  static OrderStatsByStatusModel fromQuerySnapshot(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderStatsByStatusModel.fromJson(doc.id, data);
  }
}
