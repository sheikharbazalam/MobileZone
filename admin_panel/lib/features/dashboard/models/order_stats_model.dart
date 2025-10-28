import 'package:cloud_firestore/cloud_firestore.dart';

class OrderStatsModel {
  final String id;
  final int totalOrders;
  final double totalRevenue;
  final double totalTax;
  final double totalShipping;
  final double totalDiscounts;
  final double totalPointsUsed;
  final double totalCouponDiscounts;
  final int totalItemsSold;
  final DateTime updatedAt;

  OrderStatsModel({
    required this.id,
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalTax,
    required this.totalShipping,
    required this.totalDiscounts,
    required this.totalPointsUsed,
    required this.totalCouponDiscounts,
    required this.totalItemsSold,
    required this.updatedAt,
  });

  static OrderStatsModel empty() => OrderStatsModel(
        id: '',
        totalOrders: 0,
        totalRevenue: 0.0,
        totalTax: 0.0,
        totalShipping: 0.0,
        totalDiscounts: 0.0,
        totalPointsUsed: 0.0,
        totalCouponDiscounts: 0.0,
        totalItemsSold: 0,
        updatedAt: DateTime.now(),
      );

  factory OrderStatsModel.fromJson(String id, Map<String, dynamic> json) {
    return OrderStatsModel(
      id: id,
      totalOrders: json['totalOrders'] ?? 0,
      totalRevenue: json['totalRevenue']?.toDouble() ?? 0.0,
      totalTax: json['totalTax']?.toDouble() ?? 0.0,
      totalShipping: json['totalShipping']?.toDouble() ?? 0.0,
      totalDiscounts: json['totalDiscounts']?.toDouble() ?? 0.0,
      totalPointsUsed: json['totalPointsUsed']?.toDouble() ?? 0.0,
      totalCouponDiscounts: json['totalCouponDiscounts']?.toDouble() ?? 0.0,
      totalItemsSold: json['totalItemsSold'] ?? 0,
      updatedAt: ((json['updatedAt'] ?? DateTime.now()) as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'totalTax': totalTax,
      'totalShipping': totalShipping,
      'totalDiscounts': totalDiscounts,
      'totalPointsUsed': totalPointsUsed,
      'totalCouponDiscounts': totalCouponDiscounts,
      'totalItemsSold': totalItemsSold,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Factory method to create AttributeModel from Firestore document snapshot
  factory OrderStatsModel.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return OrderStatsModel.fromJson(doc.id, data);
  }

  /// Factory method to create a list of AttributeModel from QuerySnapshot (for retrieving multiple attributes)
  static OrderStatsModel fromQuerySnapshot(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderStatsModel.fromJson(doc.id, data);
  }
}
