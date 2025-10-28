import 'package:cwt_ecommerce_admin_panel/features/admin_managment/controller/admin_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/personalization/models/user_model.dart';
import 'package:cwt_ecommerce_admin_panel/features/role_management/controllers/role/role_controller.dart';
import 'package:cwt_ecommerce_admin_panel/routes/routes.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';
import 'package:t_utils/utils/constants/enums.dart';

class AdminTable extends StatelessWidget {
  const AdminTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AdminController.instance;
    final roleController = RoleController.instance;
    return Column(
      children: [
        /// Table Header
        TTableHeader(
          buttonText: 'Create Admin',
          searchController: controller.searchTextController,
          onCreatePressed: () => Get.toNamed(TRoutes.adminCreate),
          showCreateButton: roleController.checkUserPermission(Permission.createUsers),
        ),
        SizedBox(height: TSizes().spaceBtwSections),

        /// Table
        Obx(
          () {
            return TDataTable(
              minWidth: 700,
              isLoading: controller.isLoading.value,
              sortAscending: controller.sortAscending.value,
              allItemsFetched: controller.allItemsFetched.value,
              sortColumnIndex: controller.sortColumnIndex.value,
              loadMoreButtonOnPressed: () => controller.fetchData(),
              columns: [
                 DataColumn2(label: Text('Ser'), fixedWidth: 40),
                 DataColumn2(label:  Text('Admin'), onSort: (index, asc) => controller.sortByName(index, asc), size: ColumnSize.L),
                 DataColumn2(label: Text('Email'), size: ColumnSize.M),
                 DataColumn2(label: Text('Phone Number'), size: ColumnSize.S),
                 DataColumn2(label: Text('Status')),
                 DataColumn2(label: Text('Register Date'), size: ColumnSize.S),
                 DataColumn2(label: Text('Action'), fixedWidth: 200),
              ],
              rows: controller.filteredItems.asMap().entries.map((entry) {
                final index = entry.key;
                final attribute = entry.value;
                return buildDataRow(controller,roleController , index, attribute, context);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  DataRow buildDataRow(AdminController controller,RoleController roleController ,int index, UserModel item, BuildContext context) {
    return DataRow(
      selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(
          Row(
            children: [
              TImage(
                fit: BoxFit.contain,
                backgroundColor: TColors().primaryBackground,
                imageType: item.profilePicture.isNotEmpty ? ImageType.network : ImageType.asset,
                image: item.profilePicture.isNotEmpty ? item.profilePicture : TImages.defaultImage,
              ),
              SizedBox(width: TSizes().sm),
              Expanded(
                child: Text(
                  maxLines: 2,
                  item.fullName,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge!.apply(color: TColors().primary),
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(item.email, style: Theme.of(context).textTheme.bodyLarge)),
        DataCell(Text(item.phoneNumber, style: Theme.of(context).textTheme.bodyLarge)),
        // Status Switch
        DataCell(
          TAnimatedToggleSwitch(
            current: item.isProfileActive,
            loading: controller.statusToggleSwitchLoaders[index],
            onChanged: (value) async => controller.statusToggleSwitch(index: index, toggle: value, item: item),
          ),
        ),
        DataCell(Text(item.formattedDate)),
        DataCell(
          TTableActionButtons(
            //onDeletePressed: () => controller.confirmAndMoveToBin(item),
            onViewPressed: () => Get.toNamed(TRoutes.customerDetails, arguments: item, parameters: {'id': item.id}),
            view: false,
            delete: roleController.checkUserPermission(Permission.deleteUsers),
            edit: false,
          ),
        ),
      ],
    );
  }
}
