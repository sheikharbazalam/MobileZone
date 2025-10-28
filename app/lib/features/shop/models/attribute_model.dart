import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:t_utils/t_utils.dart';

class AttributeModel {
  String id;
  String name;
  List<String> attributeValues;
  bool isActive;
  bool isSearchable;
  bool isFilterable;
  bool isColorAttribute;
  DateTime? createdAt;
  DateTime? updatedAt;

  // Constructor
  AttributeModel({
    required this.id,
    required this.name,
    required this.attributeValues,
    this.isActive = true,
    this.isSearchable = true,
    this.isFilterable = true,
    this.isColorAttribute = false,
    this.createdAt,
    this.updatedAt,
  });

  String get formattedDate => TFormatter.formatDateAndTime(createdAt);

  String get formattedUpdatedAtDate => TFormatter.formatDateAndTime(updatedAt);

  /// Convert model to JSON structure to store in Firebase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'attributeValues': attributeValues,
      'isActive': isActive,
      'isSearchable': isSearchable,
      'isFilterable': isFilterable,
      'isColorAttribute': isColorAttribute,
      'createdAt': createdAt,
      'updatedAt': DateTime.now(),
    };
  }

  /// Factory method to create AttributeModel from Firestore document snapshot
  factory AttributeModel.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AttributeModel.fromJson(doc.id, data);
  }

  /// Factory method to create a list of AttributeModel from QuerySnapshot (for retrieving multiple attributes)
  static AttributeModel fromQuerySnapshot(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AttributeModel.fromJson(doc.id, data);
  }

  /// Map JSON data to the AttributeModel with data.containsKey check
  factory AttributeModel.fromJson(String id, Map<String, dynamic> data) {
    return AttributeModel(
      id: id,
      name: data.containsKey('name') ? data['name'] ?? '' : '',
      attributeValues: data.containsKey('attributeValues') ? List<String>.from(data['attributeValues']) : [],
      isActive: data.containsKey('isActive') ? data['isActive'] ?? true : true,
      isSearchable: data.containsKey('isSearchable') ? data['isSearchable'] ?? true : true,
      isFilterable: data.containsKey('isFilterable') ? data['isFilterable'] ?? true : true,
      isColorAttribute: data.containsKey('isColorAttribute') ? data['isColorAttribute'] ?? false : false,
      createdAt: data.containsKey('createdAt') && data['createdAt'] != null ? data['createdAt']?.toDate() : null,
      updatedAt: data.containsKey('updatedAt') && data['updatedAt'] != null ? data['updatedAt']?.toDate() : null,
    );
  }

  /// Helper function to return an empty AttributeModel
  static AttributeModel empty() =>
      AttributeModel(id: '', name: '', attributeValues: [], isActive: false, isSearchable: false, isFilterable: false);
}
