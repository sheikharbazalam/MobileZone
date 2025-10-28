import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/customer_detail_controller.dart';
import 'table_source.dart';

class CustomerOrderTable extends StatelessWidget {
  const CustomerOrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CustomerDetailController.instance;
    return Obx(
      () {
        // Customers & Selected Rows are Hidden => Just to update the UI => Obx => [ProductRows]
        Visibility(visible: false, child: Text(controller.filteredCustomerOrders.length.toString()));
        Visibility(visible: false, child: Text(controller.selectedRows.length.toString()));

        // Table
        return TPaginatedDataTable(
          minWidth: 550,
          tableHeight: 640,
          dataRowHeight: kMinInteractiveDimension,
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          columns: [
            DataColumn2(label: Text(TTexts.orderId.tr), onSort: (columnIndex, ascending) => controller.sortById(columnIndex, ascending)),
            DataColumn2(label: Text(TTexts.date.tr)),
            DataColumn2(label: Text(TTexts.items.tr)),
            DataColumn2(label: Text(TTexts.status.tr), fixedWidth: TDeviceUtils.isMobileScreen(context) ? 100 : null),
            DataColumn2(label: Text(TTexts.amount.tr), numeric: true),
          ],
          source: CustomerOrdersRows(),
        );
      },
    );
  }
}
