import 'package:cwt_ecommerce_admin_panel/features/role_management/controllers/role/role_controller.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/order/order_controller.dart';
import '../../../../models/order_model.dart';

class OrderTable extends StatelessWidget {
  const OrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    final roleController = RoleController.instance;

    return Column(
      children: [
        /// Table Header
        TTableHeader(
          showCreateButton: false,
          searchController: controller.searchTextController,
          onSearchChanged: (value) => controller.searchQuery(value),
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
                  label: Text(TTexts.orderId.tr),
                  onSort: (index, asc) => controller.sortByName(index, asc),
                  size: ColumnSize.S,
                ),
                DataColumn2(label: Text(TTexts.customer.tr), size: ColumnSize.M),
                DataColumn2(label: Text(TTexts.items.tr), size: ColumnSize.S),
                DataColumn2(
                  label: Text(TTexts.orderStatus.tr),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text(TTexts.paymentStatus.tr),
                  size: ColumnSize.S,
                ),
                DataColumn2(label: Text(TTexts.amount.tr), size: ColumnSize.S),
                DataColumn2(label: Text(TTexts.date.tr), size: ColumnSize.S),
                DataColumn2(label: Text(TTexts.action.tr), fixedWidth: 100),
              ],
              rows: controller.filteredItems.asMap().entries.map((entry) {
                final index = entry.key;
                final order = entry.value;
                return buildDataRow(controller, roleController,index, order, context);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  DataRow buildDataRow(OrderController controller,RoleController roleController, int index, OrderModel item, BuildContext context) {
    return DataRow(
      selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(item.id.capitalize.toString(),
            style: Theme.of(context).textTheme.titleLarge!.apply(color: TColors().primary))),
        DataCell(
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.userName, style: Theme.of(context).textTheme.bodyLarge),
              Text(item.userEmail.toString(), style: Theme.of(context).textTheme.labelMedium, maxLines: 1),
            ],
          ),
        ),
        DataCell(CircleAvatar(child: Text(item.itemCount.toString()))),
        // DataCell(
        //   GestureDetector(
        //     onTap: () => Get.toNamed(TRoutes.editRetailer, parameters: {'id': item.retailerId}),
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(item.retailerName ?? '', style: Theme.of(context).textTheme.bodyLarge),
        //         Text(item.retailerEmail ?? '', style: Theme.of(context).textTheme.labelMedium, maxLines: 1),
        //       ],
        //     ),
        //   ),
        // ),
        DataCell(
          TContainer(
            backgroundColor: THelperFunctions.getOrderStatusColor(item.orderStatus).withValues(alpha: 0.1),
            padding: EdgeInsets.symmetric(vertical: TSizes().sm / 2, horizontal: TSizes().sm),
            child: Text(
              item.orderStatus.name[0].toUpperCase() + item.orderStatus.name.substring(1),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .apply(color: THelperFunctions.getOrderStatusColor(item.orderStatus)),
            ),
          ),
        ),
        DataCell(
          TContainer(
            backgroundColor: THelperFunctions.getPaymentStatusColor(item.paymentStatus).withValues(alpha: 0.1),
            padding: EdgeInsets.symmetric(vertical: TSizes().sm / 2, horizontal: TSizes().sm),
            child: Text(
              item.paymentStatus.name[0].toUpperCase() + item.paymentStatus.name.substring(1),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .apply(color: THelperFunctions.getPaymentStatusColor(item.paymentStatus)),
            ),
          ),
        ),
        DataCell(Text(item.calculateGrandTotal().toStringAsFixed(1), style: Theme.of(context).textTheme.titleLarge)),
        DataCell(Text(item.formattedOrderDate)),
        DataCell(
          TTableActionButtons(
            view: roleController.checkUserPermission(Permission.viewOrders),
            edit: false,
            delete: roleController.checkUserPermission(Permission.deleteOrders),
            onDeletePressed: () => controller.confirmAndDeleteItem(item),
            onViewPressed: () => Get.toNamed(TRoutes.orderDetails, arguments: item, parameters: {'id': item.docId}),
          ),
        ),
      ],
    );
  }
}
