import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../routes/routes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../product_management/controllers/order/order_controller.dart';

class DashboardOrderTable extends StatelessWidget {
  const DashboardOrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderController.instance;
    return Obx(
      () {
        // Orders & Selected Rows are Hidden => Just to update the UI => Obx => [ProductRows]
        Visibility(visible: false, child: Text(controller.filteredItems.length.toString()));
        Visibility(visible: false, child: Text(controller.selectedRows.length.toString()));

        // Table
        return TDataTable(
          minWidth: 500,
          tableHeight: 315,
          dataRowHeight: TSizes().xl * 1.2,
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          // hideFooter: true,
          hideLoadMore: true,
          columns: [
            DataColumn2(label: Text(TTexts.orderId.tr), onSort: (columnIndex, ascending) => controller.sortById(columnIndex, ascending)),
            DataColumn2(label: Text(TTexts.date.tr)),
            DataColumn2(label: Text(TTexts.items.tr)),
            DataColumn2(label: Text(TTexts.status.tr), fixedWidth: TDeviceUtils.isMobileScreen(context) ? 120 : null),
            DataColumn2(label: Text(TTexts.amount.tr)),
          ],
          rows: controller.filteredItems.take(5).map((order) {
            return DataRow2(
              onTap: () => Get.toNamed(TRoutes.orderDetails, arguments: order),
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
          }).toList(),
        );
      },
    );
  }
}
