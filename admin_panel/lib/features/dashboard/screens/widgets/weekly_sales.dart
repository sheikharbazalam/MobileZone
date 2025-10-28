import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../controllers/dashboard_controller.dart';

class TWeeklySalesGraph extends StatelessWidget {
  const TWeeklySalesGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.instance;
    return TContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TIcon(
                icon: Iconsax.graph,
                backgroundColor: Colors.brown.withValues(alpha: 0.1),
                color: Colors.brown,
                size: TSizes().md,
              ),
              SizedBox(width: TSizes().spaceBtwItems),
              Text(TTexts.weeklySales.tr, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          SizedBox(height: TSizes().spaceBtwSections),

          // Graph
          Obx(
            () => controller.weeklySales.isNotEmpty
                ? SizedBox(
                    height: 400,
                    child: BarChart(
                      BarChartData(
                        titlesData: buildFlTitlesData(controller.weeklySales),
                        borderData: FlBorderData(
                          show: true,
                          border: const Border(top: BorderSide.none, right: BorderSide.none),
                        ),
                        gridData: const FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          drawVerticalLine: true, // Remove vertical lines
                          horizontalInterval: 200, // Set your desired interval
                        ),
                        barGroups: controller.weeklySales
                            .asMap()
                            .entries
                            .map(
                              (entry) => BarChartGroupData(
                                x: entry.key,
                                barRods: [
                                  BarChartRodData(
                                    width: 30,
                                    toY: entry.value,
                                    color: TColors().primary,
                                    borderRadius: BorderRadius.circular(TSizes().sm),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                        groupsSpace: TSizes().spaceBtwItems,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(getTooltipColor: (_) => TColors().secondary),
                          touchCallback: TDeviceUtils.isDesktopScreen(context) ? (barTouchEvent, barTouchResponse) {} : null,
                        ),
                      ),
                    ),
                  )
                : SizedBox(height: 400, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [TAnimationLoader()])),
          ),
        ],
      ),
    );
  }

  // FlTitlesData buildFlTitlesData(List<double> weeklySales) {
  //   // Calculate Step height for the left pricing
  //   double maxOrder = weeklySales.reduce((a, b) => a > b ? a : b).toDouble();
  //   double stepHeight = (maxOrder / 10).ceilToDouble();
  //   return FlTitlesData(
  //     show: true,
  //     bottomTitles: AxisTitles(
  //       sideTitles: SideTitles(
  //         showTitles: true,
  //         getTitlesWidget: (value, meta) {
  //           // Map index to the desired day of the week
  //           final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  //
  //           // Calculate the index and ensure it wraps around for the correct day
  //           final index = value.toInt() % days.length;
  //
  //           // Get the day corresponding to the calculated index
  //           final day = days[index];
  //
  //           // Return a custom widget with the full day name
  //           return SideTitleWidget(
  //             space: 0,
  //             axisSide: AxisSide.bottom,
  //             child: Text(day),
  //           );
  //         },
  //       ),
  //     ),
  //     leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: stepHeight == 0 ? 1.0 : stepHeight, reservedSize: 50)),
  //     rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //     topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //   );
  // }

  FlTitlesData buildFlTitlesData(List<double> weeklySales) {
    // Get today's date
    final today = DateTime.now();
    final DateFormat dayFormat = DateFormat('E'); // Short weekday format

    final last7Days = List.generate(7, (index) {
      final day = today.subtract(Duration(days: 6 - index));
      return dayFormat.format(day); // Formats day as "Mon", "Tue", etc.
    });

    double maxOrder = weeklySales.reduce((a, b) => a > b ? a : b).toDouble();
    double stepHeight = (maxOrder / 10).ceilToDouble();

    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final day = last7Days[value.toInt() % last7Days.length];
            return SideTitleWidget(
              space: 0,
              meta: TitleMeta( // Add this TitleMeta like added here
                min: meta.min,
                max: meta.max,
                parentAxisSize: meta.parentAxisSize,
                axisPosition: meta.axisPosition,
                appliedInterval: meta.appliedInterval,
                sideTitles: meta.sideTitles,
                formattedValue: meta.formattedValue,
                axisSide: AxisSide.bottom,
                rotationQuarterTurns: meta.rotationQuarterTurns,
              ),
              // axisSide: AxisSide.bottom, // Remove this line
              child: Text(day),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: stepHeight == 0 ? 1.0 : stepHeight,
          reservedSize: 50,
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
