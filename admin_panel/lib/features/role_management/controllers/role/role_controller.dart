import 'package:cwt_ecommerce_admin_panel/data/repositories/role_repositories/role_repository.dart';
import 'package:cwt_ecommerce_admin_panel/features/personalization/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/role_model.dart';

class RoleController extends GetxController {
  static RoleController get instance => Get.isRegistered() ? Get.find() : Get.put(RoleController());

  // Inject the repository
  final RoleRepository repository = Get.put(RoleRepository());

  final sidebarLoader = false.obs;
  final loading = false.obs;
  var selectedRole = AppRole.admin.obs;
  var rolesAndPermissions = <AppRole, RoleModel>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize roles with default permissions, or fetch from Firestore
    fetchRolesAndPermissions();
    //addDefaultRolesAndPermissions();
  }

  Future<void> fetchRolesAndPermissions() async {
    try {
      loading.value = true;
      sidebarLoader.value = true;

      final rolesFromFirestore = await RoleRepository.instance.fetchAllItems();
      for (var role in rolesFromFirestore) {
        rolesAndPermissions[role.role] = role;
      }
      rolesAndPermissions.refresh();
    } catch (e) {
      TLoaders.customToast(message: 'Failed to fetch roles.');
    } finally {
      loading.value = false;
      sidebarLoader.value = false;
    }
  }

  void updatePermission(AppRole role, Permission permission, bool add) {
    try {
      var roleModel = rolesAndPermissions[role];
      if (roleModel != null) {
        if (add) {
          if (!roleModel.permissions.contains(permission)) {
            roleModel.permissions.add(permission);
          }
        } else {
          roleModel.permissions.remove(permission);
        }
        rolesAndPermissions[role] = roleModel;
        rolesAndPermissions.refresh(); // Trigger UI update
      } else {
        TLoaders.customToast(message: 'Role not found.');
      }
    } catch (e) {
      TLoaders.customToast(message: 'Permission not updated. Try again.');
    }
  }

  void changeSelectedRole(AppRole role) {
    selectedRole.value = role;
  }

  bool hasPermission(AppRole role, Permission permission) {
    return rolesAndPermissions[role]?.permissions.contains(permission) ?? false;
  }

  bool checkUserPermission(Permission requiredPermission) {
    final userController = UserController.instance;

    // If the role has no permissions, return false
    if (rolesAndPermissions.isEmpty) return false;

    final roleWithPermissions = rolesAndPermissions[userController.user.value.role];

    // If the role has no permissions, return false
    if (roleWithPermissions == null || roleWithPermissions == RoleModel.empty) return false;

    // Check if the user has the required permission
    final response = roleWithPermissions.permissions.contains(requiredPermission);

    return response;
  }

  bool checkUserPermissions(List<Permission> requiredPermissions) {
    final user = UserController.instance.user;

    // If there are no roles and permissions defined, return false
    if (rolesAndPermissions.isEmpty) return false;

    // Get the role with its permissions for the current user
    final roleWithPermissions = rolesAndPermissions[user.value.role];

    // If the role has no permissions, return false
    if (roleWithPermissions == null || roleWithPermissions == RoleModel.empty) return false;

    // Check if any of the required permissions exist in the user's permissions
    return requiredPermissions.any((permission) => roleWithPermissions.permissions.contains(permission));
  }

  Future<void> addDefaultRolesAndPermissions() async {
    // Define default roles and their corresponding permissions using the Role enum
    final Map<AppRole, List<Permission>> defaultRoles = {
      // Super Admin and Admin: full access
      AppRole.superAdmin: Permission.values,
      AppRole.admin: Permission.values,

      // Fallback
      AppRole.unknown: [Permission.unknown],
      AppRole.user: [Permission.unknown],
      AppRole.demo: [Permission.unknown],
    };


    try {
      // Loop through each role and its permissions
      for (var entry in defaultRoles.entries) {
        AppRole roleEnum = entry.key;
        List<Permission> permissions = entry.value;

        // Create a RoleModel instance
        RoleModel roleModel = RoleModel(id: '', role: roleEnum, permissions: permissions);

        // Save the role with its permissions to the database
        await repository.addNewItem(roleModel);
      }
    } catch (e) {
      debugPrint('Error adding default roles and permissions: $e');
    }
  }

  Future<void> savePermissionsToFirestore() async {
    try {
      loading.value = true;
      final roleModel = rolesAndPermissions[selectedRole.value];
      if (roleModel != null && roleModel.permissions.isNotEmpty) {
        await RoleRepository.instance.updateItem(roleModel);
        TLoaders.customToast(message: '🎊 Permissions saved successfully.');
      } else {
        TLoaders.customToast(message: 'No permissions to save.');
      }
    } catch (e) {
      TLoaders.customToast(message: 'Failed to save permissions.');
    } finally {
      loading.value = false;
    }
  }
}
