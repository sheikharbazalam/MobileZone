import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:t_utils/t_utils.dart';
import '../../../../../../routes/routes.dart';
import '../../../../controllers/unit/unit_controller.dart';
import '../../../../models/unit_model.dart';

class UnitTable extends StatelessWidget {
  const UnitTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UnitController());
    return Column(
      children: [
        /// Table Header
        TTableHeader(
          buttonText: 'Create New Unit',
          searchController: controller.searchTextController,
          onCreatePressed: () => Get.toNamed(TRoutes.createUnit),
          onSearchChanged: (value) => controller.searchQuery(value),
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
                DataColumn2(label: const Text('Unit'), onSort: (index, asc) => controller.sortByName(index, asc)),
                const DataColumn2(label: Text('Abbreviation')),
                const DataColumn2(label: Text('Type')),
                const DataColumn2(label: Text('Search Keywords')),
                const DataColumn2(label: Text('Conversion Factor')),
                const DataColumn2(label: Text('Base Unit')),
                const DataColumn2(label: Text('Date')),
                const DataColumn2(label: Text('Action'), fixedWidth: 100),
              ],
              rows: controller.filteredItems.asMap().entries.map((entry) {
                final index = entry.key;
                final attribute = entry.value;
                return buildDataRow(controller, index, attribute, context);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  DataRow buildDataRow(UnitController controller, int index, UnitModel item, BuildContext context) {
    return DataRow(
      selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(item.unitName.capitalize.toString(), style: Theme.of(context).textTheme.titleLarge!.apply(color: TColors().primary))),
        DataCell(Text(item.abbreviation, style: Theme.of(context).textTheme.bodyLarge)),
        DataCell(Chip(label: Text(item.unitType.name.capitalize.toString()))),
        DataCell(Text(
          item.searchKeywords != null ? item.searchKeywords!.map((v) => v.trim()).join(', ') : '',
          style: Theme.of(context).textTheme.bodyLarge,
        )),
        DataCell(Text(item.conversionFactor.toString(), style: Theme.of(context).textTheme.bodyLarge)),
        DataCell(item.isBaseUnit
            ? TIcon(icon: CupertinoIcons.check_mark_circled_solid, color: TColors().primary)
            : TIcon(icon: CupertinoIcons.clear_circled, color: TColors().darkerGrey)),
        DataCell(Text(item.createdAt == null ? '' : item.formattedDate)),
        DataCell(
          TTableActionButtons(
            onDeletePressed: () => controller.confirmAndDeleteItem(item),
            onEditPressed: () => Get.toNamed(TRoutes.editUnit, arguments: item, parameters: {'id': item.id}),
          ),
        ),
      ],
    );
  }
}
