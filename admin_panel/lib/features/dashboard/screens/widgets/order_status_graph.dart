import 'package:cwt_ecommerce_admin_panel/utils/constants/exports.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';

import '../../controllers/dashboard_controller.dart';

class OrderStatusPieChart extends StatelessWidget {
  const OrderStatusPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => controller.getTotalOrders() > 0
              ? SizedBox(
                  height: 400,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: TDeviceUtils.isTabletScreen(context) ? 80 : 55,
                      startDegreeOffset: 180,
                      sections: _buildChartSections(controller),
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          // Handle touch events here if needed
                        },
                        enabled: true,
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: 400,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    TAnimationLoader(
                      animation: TImages.emptyAnimation,
                      isLottieAnimation: true,
                    )
                  ]),
                ),
        ),

        // Show Status and Color Meta
        SizedBox(
          width: double.infinity,
          child: Obx(
            () => DataTable(
              columns: [
                DataColumn(label: Text(TTexts.status.tr)),
                DataColumn(label: Text(TTexts.ordersStatus.tr)),
              ],
              rows: _buildDataTableRows(controller),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildChartSections(DashboardController controller) {
    final List<PieChartSectionData> sections = [];

    for (OrderStatus status in OrderStatus.values) {
      final count = controller.getOrderCount(status);

      if (count > 0) {
        sections.add(
          PieChartSectionData(
            showTitle: true,
            color: THelperFunctions.getOrderStatusColor(status),
            value: count.toDouble(),
            title: '$count',
            radius: 100,
            titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }
    }

    return sections;
  }

  List<DataRow> _buildDataTableRows(DashboardController controller) {
    final List<DataRow> rows = [];

    for (OrderStatus status in OrderStatus.values) {
      final count = controller.getOrderCount(status);

      if (count > 0) {
        rows.add(
          DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    TContainer(
                      width: 20,
                      height: 20,
                      backgroundColor: THelperFunctions.getOrderStatusColor(status),
                    ),
                    Expanded(child: Text(' ${controller.getDisplayStatusName(status)}')),
                  ],
                ),
              ),
              DataCell(Text(count.toString())),
            ],
          ),
        );
      }
    }

    return rows;
  }
}
