import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/constants/enums.dart';

class RoleModel {
  String id;
  AppRole role;
  List<Permission> permissions;

  RoleModel({
    required this.id,
    required this.role,
    required this.permissions,
  });

  static RoleModel get empty => RoleModel(id: '', role: AppRole.unknown, permissions: []);

  Map<String, dynamic> toJson() {
    return {
      'role': role.name,
      'permissions': permissions.map((e) => e.name).toList(),
    };
  }

  factory RoleModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return RoleModel(
      id: doc.id,
      role: data.containsKey('role')
          ? AppRole.values.firstWhere((e) => e.name.toString() == (data['role'] ?? AppRole.unknown), orElse: () => AppRole.unknown)
          : AppRole.unknown,
      permissions: data.containsKey('permissions')
          ? (data['permissions'] as List<dynamic>)
              .map((permission) => Permission.values.firstWhere((e) => e.name.toString() == permission))
              .toList()
          : [],
    );
  }

  AppRole stringToEnum(String role) {
    return AppRole.values.firstWhere((e) => e.name.toString() == role, orElse: () => AppRole.unknown);
  }
}
