import 'package:cloud_firestore/cloud_firestore.dart';

class RetailerStatsModel {
  final String id;
  final int totalOrders;
  final double totalRevenue;
  final double totalTax;
  final double totalShipping;
  final double totalDiscount;
  final double totalPointsUsed;
  final double totalCouponDiscount;
  final int totalItemsSold;
  final DateTime updatedAt;

  RetailerStatsModel({
    required this.id,
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalTax,
    required this.totalShipping,
    required this.totalDiscount,
    required this.totalPointsUsed,
    required this.totalCouponDiscount,
    required this.totalItemsSold,
    required this.updatedAt,
  });

  factory RetailerStatsModel.fromJson(String id, Map<String, dynamic> json) {
    return RetailerStatsModel(
      id: id,
      totalOrders: json['totalOrders'] ?? 0,
      totalRevenue: json['totalRevenue']?.toDouble() ?? 0.0,
      totalTax: json['totalTax']?.toDouble() ?? 0.0,
      totalShipping: json['totalShipping']?.toDouble() ?? 0.0,
      totalDiscount: json['totalDiscount']?.toDouble() ?? 0.0,
      totalPointsUsed: json['totalPointsUsed']?.toDouble() ?? 0.0,
      totalCouponDiscount: json['totalCouponDiscount']?.toDouble() ?? 0.0,
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
      'totalDiscount': totalDiscount,
      'totalPointsUsed': totalPointsUsed,
      'totalCouponDiscount': totalCouponDiscount,
      'totalItemsSold': totalItemsSold,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Factory method to create AttributeModel from Firestore document snapshot
  factory RetailerStatsModel.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return RetailerStatsModel.fromJson(doc.id, data);
  }

  /// Factory method to create a list of AttributeModel from QuerySnapshot (for retrieving multiple attributes)
  static RetailerStatsModel fromQuerySnapshot(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RetailerStatsModel.fromJson(doc.id, data);
  }
}
