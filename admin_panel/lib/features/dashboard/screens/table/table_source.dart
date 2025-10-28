import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../routes/routes.dart';
import '../../../product_management/controllers/order/order_controller.dart';

class OrderRows extends DataTableSource {
  final controller = OrderController.instance;

  @override
  DataRow? getRow(int index) {
    final order = controller.filteredItems[index];
    return DataRow2(
      onTap: () => Get.toNamed(TRoutes.orderDetails, arguments: order),
      selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Text(
            order.id,
            style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: TColors().primary),
          ),
        ),
        DataCell(Text(order.formattedOrderDate)),
        DataCell(Text('${order.products.length} Items')),
        DataCell(
          TContainer(
            padding: EdgeInsets.symmetric(vertical: TSizes().xs, horizontal: TSizes().md),
            backgroundColor: THelperFunctions.getOrderStatusColor(order.orderStatus).withValues(alpha: 0.1),
            child: Text(
              order.orderStatus.name.capitalize.toString(),
              style: TextStyle(color: THelperFunctions.getOrderStatusColor(order.orderStatus)),
            ),
          ),
        ),
        DataCell(Text('\$${order.totalAmount}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount => controller.selectedRows.where((selected) => selected).length;
}
