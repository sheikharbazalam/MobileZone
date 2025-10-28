import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';
import '../../../../../../utils/exports.dart';
import '../../../../controllers/role/role_controller.dart';

class PermissionTable extends StatelessWidget {
  PermissionTable({super.key});

  final controller = RoleController.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Roles Dropdown
            SizedBox(
              width: 200,
              child: Obx(
                () => DropdownButtonFormField<AppRole>(
                  dropdownColor: Colors.white,
                  decoration: const InputDecoration(labelText: 'Roles', fillColor: Colors.white),
                  value: controller.selectedRole.value,
                  onChanged: (AppRole? newRole) {
                    if (newRole != null) {
                      controller.changeSelectedRole(newRole);
                    }
                  },
                  items: AppRole.values.where((role) => role != AppRole.superAdmin).map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role.name.capitalize.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ),
            ),

            SizedBox(
              width: 200,
              child: Obx(
                () => ElevatedButton(
                    onPressed: controller.loading.value ? () {} : () => controller.savePermissionsToFirestore(),
                    // onPressed: controller.loading.value ? () {} : () => controller.addDefaultRolesAndPermissions(),
                    child: controller.loading.value ? const Text('Processing...') : const Text('Save Permissions')),
              ),
            ),
          ],
        ),
        SizedBox(height: TSizes().spaceBtwSections),

        /// Table
        Obx(
          () {
            return TDataTable(
              dataRowHeight: 78,
              hideFooter: true,
              hideLoadMore: true,
              isLoading: controller.loading.value,
              columns: const [
                DataColumn2(label: Text('Permission')),
                DataColumn2(label: Text('View')),
                DataColumn2(label: Text('Create')),
                DataColumn2(label: Text('Update')),
                DataColumn2(label: Text('Delete')),
              ],
              rows: controller.loading.value
                  ? []
                  : [
                      buildDataRow('Media', Permission.viewMedia, Permission.createMedia, Permission.editMedia, Permission.deleteMedia),
                      buildDataRow('Category', Permission.viewCategory, Permission.createCategory, Permission.updateCategory,
                          Permission.deleteCategory),
                      buildDataRow('Sub-Category', Permission.viewSubCategory, Permission.createSubCategory, Permission.updateSubCategory,
                          Permission.deleteSubCategory),
                      buildDataRow('Attributes', Permission.viewAttribute, Permission.createAttribute, Permission.updateAttribute,
                          Permission.deleteAttribute),
                      buildDataRow('Brand', Permission.viewBrand, Permission.createBrand, Permission.updateBrand, Permission.deleteBrand),
                      buildDataRow('Unit', Permission.viewUnit, Permission.createUnit, Permission.updateUnit, Permission.deleteUnit),
                      buildDataRow('Products', Permission.viewProducts, Permission.createProducts, Permission.updateProducts,
                          Permission.deleteProducts),
                      buildDataRow(
                          'Orders', Permission.viewOrders, Permission.createOrders, Permission.updateOrders, Permission.deleteOrders),
                      buildDataRow('Recommended Product', Permission.viewRecommendedProduct, Permission.createRecommendedProduct,
                          Permission.updateRecommendedProduct, Permission.deleteRecommendedProduct),
                      buildDataRow(
                          'Review', Permission.viewReview, Permission.createReview, Permission.updateReview, Permission.deleteReview),
                      buildDataRow(
                          'Banner', Permission.viewBanner, Permission.createBanner, Permission.updateBanner, Permission.deleteBanner),
                      buildDataRow(
                          'Coupon', Permission.viewCoupon, Permission.createCoupon, Permission.updateCoupon, Permission.deleteCoupon),
                      buildDataRow('Users', Permission.viewUsers, Permission.createUsers, Permission.updateUsers, Permission.deleteUsers),
                      buildDataRow('Roles', Permission.viewRoles, Permission.createRoles, Permission.updateRoles, Permission.deleteRoles),
                      buildDataRow('Notifications', Permission.viewNotifications, Permission.createNotifications,
                          Permission.updateNotifications, Permission.deleteNotifications),
                      buildDataRow('Settings', Permission.viewSettings, Permission.createSettings, Permission.updateSettings,
                          Permission.deleteSettings),
                    ],
            );
          },
        ),
      ],
    );
  }

  DataRow buildDataRow(String label, Permission view, Permission create, Permission update, Permission delete) {
    return DataRow(
      cells: [
        DataCell(Text(label)),
        DataCell(
          Checkbox(
            value: controller.hasPermission(controller.selectedRole.value, view),
            onChanged: (bool? value) {
              if (value != null) {
                debugPrint(value.toString());
                controller.updatePermission(controller.selectedRole.value, view, value);
              }
            },
          ),
        ),
        DataCell(
          Checkbox(
            value: controller.hasPermission(controller.selectedRole.value, create),
            onChanged: (bool? value) {
              if (value != null) {
                controller.updatePermission(controller.selectedRole.value, create, value);
              }
            },
          ),
        ),
        DataCell(
          Checkbox(
            value: controller.hasPermission(controller.selectedRole.value, update),
            onChanged: (bool? value) {
              if (value != null) {
                controller.updatePermission(controller.selectedRole.value, update, value);
              }
            },
          ),
        ),
        DataCell(
          Checkbox(
            value: controller.hasPermission(controller.selectedRole.value, delete),
            onChanged: (bool? value) {
              if (value != null) {
                controller.updatePermission(controller.selectedRole.value, delete, value);
              }
            },
          ),
        ),
      ],
    );
  }
}
