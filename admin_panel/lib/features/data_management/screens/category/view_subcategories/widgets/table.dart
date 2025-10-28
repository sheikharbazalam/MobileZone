import 'package:cwt_ecommerce_admin_panel/features/role_management/controllers/role/role_controller.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../controllers/category/category_controller.dart';
import '../../../../models/category_model.dart';

class CategoryTable extends StatelessWidget {
  const CategoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    final roleController = RoleController.instance;

    return Column(
      children: [
        /// Table Header
        TTableHeader(
          buttonText: 'Create Sub-Category',
          searchController: controller.searchTextController,
          onCreatePressed: () => Get.toNamed(TRoutes.createSubCategory),
          onSearchChanged: (value) => controller.searchQuery(value),
          showCreateButton: roleController.checkUserPermission(Permission.createSubCategory),
        ),
        SizedBox(height: TSizes().spaceBtwSections),

        /// Table
        Obx(
          () {
            return TDataTable(
              minWidth: 1100,
              isLoading: controller.isLoading.value,
              sortAscending: controller.sortAscending.value,
              allItemsFetched: controller.allItemsFetched.value,
              sortColumnIndex: controller.sortColumnIndex.value,
              loadMoreButtonOnPressed: () => controller.fetchData(),
              columns: [
                const DataColumn2(label: Text('Ser'), fixedWidth: 40),
                DataColumn2(label: const Text('Sub Category'), onSort: (index, asc) => controller.sortByName(index, asc)),
                const DataColumn2(label: Text('Category')),
                const DataColumn2(label: Text('Featured')),
                const DataColumn2(label: Text('Status')),
                const DataColumn2(label: Text('Date')),
                const DataColumn2(label: Text('Action '), fixedWidth: 126),
              ],
              rows: controller.filteredItems.where((item) => item.parentId.isNotEmpty).toList().asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                return buildDataRow(controller, roleController,index, category, context);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  DataRow buildDataRow(CategoryController controller,RoleController roleController, int index, CategoryModel item, BuildContext context) {
    final parentCategory = controller.allItems.firstWhere(
          (i) => i.id == item.parentId,
      orElse: () => CategoryModel.empty(), // Fallback to an empty CategoryModel if not found
    );

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
                backgroundColor: TColors().lightBackground,
                imageType: item.imageURL.isNotEmpty ? ImageType.network : ImageType.asset,
                image: item.imageURL.isNotEmpty ? item.imageURL : TImages.user,
              ),
              SizedBox(width: TSizes().spaceBtwItems),
              Expanded(child: Text(item.name.capitalize.toString(), style: Theme.of(context).textTheme.titleLarge)),
            ],
          ),
        ),
        DataCell(
          TContainer(
            showRipple: true,
            padding: EdgeInsets.all(TSizes().sm),
            backgroundColor: TColors().primary.withValues(alpha: 0.1),
            onTap: () => Get.toNamed(TRoutes.editCategory, arguments: item, parameters: {'id': item.id}),
            child: Text(
              parentCategory.name.capitalize.toString(),
              style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors().primary),
            ),
          ),
        ),
        DataCell(
          TAnimatedToggleSwitch(
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
            onEditPressed: () => Get.toNamed(
              TRoutes.editSubCategory,
              arguments: item,
              parameters: {'id': item.id},
            ),
            delete: roleController.checkUserPermission(Permission.deleteSubCategory),
            edit: roleController.checkUserPermission(Permission.updateSubCategory),
          ),
        ),
      ],
    );
  }
}
