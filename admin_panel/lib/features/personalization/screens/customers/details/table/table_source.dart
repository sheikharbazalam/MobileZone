import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../controllers/customer_detail_controller.dart';

class CustomerOrdersRows extends DataTableSource {
  final controller = CustomerDetailController.instance;

  @override
  DataRow? getRow(int index) {
    final order = controller.filteredCustomerOrders[index];
    return DataRow2(
      onTap: () => Get.toNamed(TRoutes.orderDetails, arguments: order),
      selected: controller.selectedRows[index],
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
            radius: TSizes().cardRadiusSm,
            padding: EdgeInsets.symmetric(vertical: TSizes().sm, horizontal: TSizes().md),
            backgroundColor: THelperFunctions.getOrderStatusColor(order.orderStatus).withValues(alpha: 0.1),
            child: Text(
              order.orderStatus.name.capitalize.toString(),
              style: TextStyle(color: THelperFunctions.getOrderStatusColor(order.orderStatus)),
            ),
          ),
        ),
        DataCell(Text('\$${order.calculateGrandTotal().toStringAsFixed(1)}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredCustomerOrders.length;

  @override
  int get selectedRowCount => controller.selectedRows.where((selected) => selected).length;
}
