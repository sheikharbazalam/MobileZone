import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/constants/enums.dart';

import 'package:t_utils/t_utils.dart';


enum CampaignType { retailer, product }

class CampaignModel {
  String id;
  String title;
  String description;
  CampaignType type; // Retailer or Product based
  DiscountType discountType;
  List<String> relatedIds; // List of Retailer IDs or Product IDs
  double discountValue;
  DateTime? startDate;
  DateTime? endDate;
  bool isActive;
  bool isFeatured;
  List<String>? associatedBanners; // Optional banners for the campaign
  int clickCount; // For tracking engagement
  DateTime? createdAt;
  DateTime? updatedAt;

  CampaignModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.type,
    required this.discountType,
    required this.relatedIds,
    required this.discountValue,
    this.startDate,
    this.endDate,
    this.isActive = true,
    this.isFeatured = false,
    this.associatedBanners,
    this.clickCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  String get formattedDate => TFormatter.formatDate(createdAt);

  String get formattedUpdateDate => TFormatter.formatDate(updatedAt);

  String get formattedStartDate => TFormatter.formatDate(startDate);

  String get formattedEndDate => TFormatter.formatDate(endDate);

  // Convert to JSON for Firestore storage
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type.name,
      'discountType': discountType.name,
      'relatedIds': relatedIds,
      'discountValue': discountValue,
      'startDate': startDate,
      'endDate': endDate,
      'isActive': isActive,
      'associatedBanners': associatedBanners,
      'clickCount': clickCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Retrieve from Firestore JSON
  static CampaignModel fromJson(String id, Map<String, dynamic> data) {
    return CampaignModel(
      id: id,
      title: data['title'],
      description: data['description'],
      type: data.containsKey('type')
          ? CampaignType.values.firstWhere((e) => e.name == data['type'], orElse: () => CampaignType.product)
          : CampaignType.product,
      discountType: data.containsKey('discountType')
          ? DiscountType.values.firstWhere((e) => e.name == data['discountType'], orElse: () => DiscountType.percentage)
          : DiscountType.percentage,
      relatedIds: List<String>.from(data['relatedIds']),
      discountValue: data['discountValue'],
      startDate: data['startDate'].toDate(),
      endDate: data['endDate'].toDate(),
      isActive: data['isActive'],
      associatedBanners: data.containsKey('associatedBanners') ? List<String>.from(data['associatedBanners']) : null,
      clickCount: data['clickCount'] ?? 0,
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
    );
  }

  /// Factory method to create AttributeModel from Firestore document snapshot
  factory CampaignModel.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CampaignModel.fromJson(doc.id, data);
  }

  /// Factory method to create a list of AttributeModel from QuerySnapshot (for retrieving multiple attributes)
  static CampaignModel fromQuerySnapshot(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CampaignModel.fromJson(doc.id, data);
  }

  static CampaignModel empty() => CampaignModel(id: '', discountValue: 0, type: CampaignType.product, title: '', relatedIds: [], discountType: DiscountType.percentage);
}
