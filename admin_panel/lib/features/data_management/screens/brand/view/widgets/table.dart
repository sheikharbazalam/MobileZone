import 'package:cwt_ecommerce_admin_panel/features/role_management/controllers/role/role_controller.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../controllers/brand/brand_controller.dart';
import '../../../../models/brand_model.dart';

class BrandTable extends StatelessWidget {
  const BrandTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandController());
    final roleController = RoleController.instance;

    return Column(
      children: [
        /// Table Header
        TTableHeader(
          buttonText: 'Create New Brand',
          searchController: controller.searchTextController,
          onCreatePressed: () => Get.toNamed(TRoutes.createBrand),
          onSearchChanged: (value) => controller.searchQuery(value),
          showCreateButton: roleController.checkUserPermission(Permission.createBrand),
        ),
        SizedBox(height: TSizes().spaceBtwSections),

        /// Table
        Obx(
          () {
            return TDataTable(
              minWidth: 900,
              isLoading: controller.isLoading.value,
              sortAscending: controller.sortAscending.value,
              allItemsFetched: controller.allItemsFetched.value,
              sortColumnIndex: controller.sortColumnIndex.value,
              loadMoreButtonOnPressed: () => controller.fetchData(),
              columns: [
                const DataColumn2(label: Text('Ser'), fixedWidth: 40),
                DataColumn2(label: const Text('Brand'), onSort: (index, asc) => controller.sortByName(index, asc)),
                const DataColumn2(label: Text('Categories')),
                const DataColumn2(label: Text('Featured')),
                const DataColumn2(label: Text('Status')),
                const DataColumn2(label: Text('Date')),
                const DataColumn2(label: Text('Action '), fixedWidth: 100),
              ],
              rows: controller.filteredItems.asMap().entries.map((entry) {
                final index = entry.key;
                final brand = entry.value;
                return buildDataRow(controller,roleController, index, brand, context);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  DataRow buildDataRow(BrandController controller,RoleController roleController , int index, BrandModel item, BuildContext context) {
    return DataRow(
      selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(
          Row(
            children: [
              TImage(
                padding: 0,
                fit: BoxFit.contain,
                backgroundColor: Colors.transparent,
                imageType: item.imageURL.isNotEmpty ? ImageType.network : ImageType.asset,
                image: item.imageURL.isNotEmpty ? item.imageURL : TImages.user,
              ),
              SizedBox(width: TSizes().spaceBtwItems),
              Expanded(
                child: Text(
                  item.name.capitalize.toString(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),

        DataCell(CircleAvatar(child: Text(item.categories != null ? item.categories!.length.toString() : '0'))),
        DataCell(
          TAnimatedToggleSwitch(
            textBuilder: (value) => const Text('Featured'),
            current: item.isFeatured,
            loading: controller.featuredToggleSwitchLoaders[index],
            onChanged: (value) async => controller.featuredToggleSwitch(index: index, toggle: value, item: item),
          ),
        ),
        // Active Switch
        DataCell(
          TAnimatedToggleSwitch(
            current: item.isActive,
            loading: controller.statusToggleSwitchLoaders[index],
            onChanged: (value) async => controller.statusToggleSwitch(index: index, toggle: value, item: item),
          ),
        ),
        DataCell(Text(item.createdAt == null ? '' : item.formattedDate)),
        DataCell(
          TTableActionButtons(
            onDeletePressed: () => controller.confirmAndDeleteItem(item),
            onEditPressed: () => Get.toNamed(TRoutes.editBrand, arguments: item, parameters: {'id': item.id}),
            delete: roleController.checkUserPermission(Permission.deleteBrand),
            edit: roleController.checkUserPermission(Permission.updateBrand),
          ),
        ),
      ],
    );
  }
}
