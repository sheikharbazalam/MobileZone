// Define the Unit model
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:t_utils/utils/constants/enums.dart';
import 'package:t_utils/utils/formatters/formatter.dart';

class UnitModel {
  String id;
  String unitName; // Full name, e.g., "Kilogram"
  String abbreviation; // e.g., "kg"
  UnitType unitType; // Enum for unit type
  double conversionFactor; // Conversion rate (e.g., 1 for kg, 1000 for gram)
  bool isBaseUnit; // True if it's the base unit for a type
  DateTime? createdAt;
  DateTime? updatedAt;
  bool isActive;
  List<String>? searchKeywords; // For search-ability

  // Constructor
  UnitModel({
    required this.id,
    required this.unitName,
    required this.abbreviation,
    required this.unitType,
    required this.conversionFactor,
    this.isBaseUnit = false,
    this.createdAt,
    this.updatedAt,
    this.isActive = false,
    this.searchKeywords,
  });

  /// Helper function to return an empty AttributeModel
  static UnitModel empty() => UnitModel(id: '', unitName: '', abbreviation: '', conversionFactor: 1, unitType: UnitType.unitLess);

  String get formattedDate => TFormatter.formatDateAndTime(createdAt);

  String get formattedUpdatedAtDate => TFormatter.formatDateAndTime(updatedAt);

  /// Factory method to create AttributeModel from Firestore document snapshot
  factory UnitModel.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UnitModel.fromJson(doc.id, data);
  }

  /// Factory method to create a list of AttributeModel from QuerySnapshot (for retrieving multiple attributes)
  static UnitModel fromQuerySnapshot(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UnitModel.fromJson(doc.id, data);
  }

  // Method to convert the model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unitName': unitName,
      'abbreviation': abbreviation,
      'unitType': unitType.name, // Save enum as a string using .name
      'conversionFactor': conversionFactor,
      'isBaseUnit': isBaseUnit,
      'createdAt': createdAt,
      'updatedAt': DateTime.now(),
      'isActive': isActive,
      'searchKeywords': searchKeywords,
    };
  }

  // Factory constructor to create an instance of Unit from a JSON object
  factory UnitModel.fromJson(String id, Map<String, dynamic> json) {
    return UnitModel(
      id: id,
      unitName: json['unitName'],
      abbreviation: json['abbreviation'],
      // Convert the string back to enum by matching it with UnitType's name
      unitType: UnitType.values.firstWhereOrNull((e) => e.name == json['unitType']) ?? UnitType.unitLess,
      conversionFactor: (json['conversionFactor'] as num).toDouble(),
      isBaseUnit: json['isBaseUnit'] ?? false,
      createdAt: json['createdAt']?.toDate(),
      updatedAt: json['updatedAt']?.toDate(),
      isActive: json['isActive'] ?? true,
      searchKeywords: List<String>.from(json['searchKeywords'] ?? []),
    );
  }
}
