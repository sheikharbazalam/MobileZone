import 'package:cwt_ecommerce_admin_panel/features/role_management/controllers/role/role_controller.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../data/services/notification/notification_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/notification/notification_controller.dart';

class NotificationTable extends StatelessWidget {
  const NotificationTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    final roleController = RoleController.instance;

    return Column(
      children: [
        /// Table Header
        TTableHeader(
          buttonText: TTexts.createNewNotification.tr,
          searchController: controller.searchTextController,
          onCreatePressed: () => Get.toNamed(TRoutes.createNotification),
          onSearchChanged: (value) => controller.searchQuery(value),
          showCreateButton: roleController.checkUserPermission(Permission.createNotifications),
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
                DataColumn2(label: Text(TTexts.ser.tr), fixedWidth: 40),
                DataColumn2(
                    label: Text(TTexts.notification.tr),
                    onSort: (index, asc) => controller.sortByName(index, asc),
                    size: ColumnSize.L),
                DataColumn2(label: Text(TTexts.notificationType.tr), size: ColumnSize.S),
                DataColumn2(label: Text(TTexts.notificationTableSent.tr), size: ColumnSize.S),
                DataColumn2(label: Text(TTexts.notificationTableDate.tr), size: ColumnSize.S),
                DataColumn2(label: Text(TTexts.notificationTableAction.tr), fixedWidth: 70),
              ],
              rows: controller.filteredItems.asMap().entries.map((entry) {
                final index = entry.key;
                final coupon = entry.value;
                return buildDataRow(controller, roleController,index, coupon, context);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  DataRow buildDataRow(NotificationController controller,RoleController roleController, int index, NotificationModel item, BuildContext context) {
    return DataRow(
      selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: Theme.of(context).textTheme.titleSmall!.apply(color: TColors().primary), maxLines: 1),
              Text(item.body, style: Theme.of(context).textTheme.bodyMedium, maxLines: 2),
            ],
          ),
        ),
        DataCell(
          TContainer(
            backgroundColor: TColors().primary.withValues(alpha: 0.1),
            padding: EdgeInsets.symmetric(vertical: TSizes().sm / 2, horizontal: TSizes().sm),
            child: Text(item.type, style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors().primary)),
          ),
        ),
        DataCell(Text(item.formattedSentDate)),
        DataCell(Text(item.formattedDate)),
        DataCell(
          TTableActionButtons(
            edit: false,
            onDeletePressed: () => controller.confirmAndDeleteItem(item),
            delete: roleController.checkUserPermission(Permission.deleteNotifications),
          ),
        ),
      ],
    );
  }
}
