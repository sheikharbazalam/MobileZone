import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../controllers/dashboard_controller.dart';
import '../table/data_table.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/order_status_graph.dart';
import '../widgets/weekly_sales.dart';

class DashboardDesktopScreen extends StatelessWidget {
  const DashboardDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes().defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(
                  iconData: Iconsax.chart_2, heading: TTexts.dashboardTypes.tr, breadcrumbItems: [TTexts.dashboard.tr]),
              SizedBox(height: TSizes().spaceBtwSections),

              // Body
              // Card Stats
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.note,
                        headingIconColor: Colors.blue,
                        headingIconBgColor: Colors.blue.withValues(alpha: 0.1),
                        stats: controller.revenuePercentage.value.toStringAsFixed(1),
                        comparedTo: DateFormat('y').format(DateTime(DateTime.now().year - 1)),
                        context: context,
                        title: 'Sales total',
                        subTitle: '\$${controller.recentYearStats.value.totalRevenue.toStringAsFixed(2)}',
                        icon: controller.revenuePercentage.value >= 0 ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                        color: controller.revenuePercentage.value >= 0 ? TColors().success : TColors().error,
                      ),
                    ),
                  ),
                  SizedBox(width: TSizes().spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.external_drive,
                        headingIconColor: Colors.green,
                        headingIconBgColor: Colors.green.withValues(alpha: 0.1),
                        stats: controller.averagePercentage.value.toStringAsFixed(1),
                        comparedTo: DateFormat('y').format(DateTime(DateTime.now().year - 1)),
                        context: context,
                        title: 'Average Order Value',
                        subTitle: controller.recentYearStats.value.totalOrders < 1
                            ? '\$0'
                            : '\$${(controller.recentYearStats.value.totalRevenue / controller.recentYearStats.value.totalOrders).toStringAsFixed(2)}',
                        icon: controller.averagePercentage.value >= 0 ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                        color: controller.averagePercentage.value >= 0 ? TColors().success : TColors().error,
                      ),
                    ),
                  ),
                  SizedBox(width: TSizes().spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.box,
                        headingIconColor: Colors.deepPurple,
                        headingIconBgColor: Colors.deepPurple.withValues(alpha: 0.1),
                        stats: controller.ordersPercentage.value.toStringAsFixed(1),
                        comparedTo: DateFormat('y').format(DateTime(DateTime.now().year - 1)),
                        context: context,
                        title: TTexts.totalOrders.tr,
                        subTitle: '${controller.recentYearStats.value.totalOrders}',
                        icon: controller.ordersPercentage.value >= 0 ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                        color: controller.ordersPercentage.value >= 0 ? TColors().success : TColors().error,
                      ),
                    ),
                  ),
                  SizedBox(width: TSizes().spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.user,
                        headingIconColor: Colors.deepOrange,
                        headingIconBgColor: Colors.deepOrange.withValues(alpha: 0.1),
                        stats: controller.soldProductsPercentage.value.toStringAsFixed(1),
                        comparedTo: DateFormat('y').format(DateTime(DateTime.now().year - 1)),
                        context: context,
                        title: TTexts.soldProducts.tr,
                        subTitle: '${controller.recentYearStats.value.totalItemsSold}',
                        icon: controller.soldProductsPercentage.value >= 0 ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                        color: controller.soldProductsPercentage.value >= 0 ? TColors().success : TColors().error,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: TSizes().spaceBtwSections),

              // Graphs
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Weekly Sales Graph
                        const TWeeklySalesGraph(),
                        SizedBox(height: TSizes().spaceBtwSections),

                        // Orders
                        TContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  TIcon(
                                    icon: Iconsax.box,
                                    backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
                                    color: Colors.deepPurple,
                                    size: TSizes().md,
                                  ),
                                  SizedBox(width: TSizes().spaceBtwItems),
                                  Text(TTexts.recentOrders.tr, style: Theme.of(context).textTheme.headlineSmall),
                                ],
                              ),
                              SizedBox(height: TSizes().spaceBtwSections),
                              const DashboardOrderTable(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: TSizes().spaceBtwSections),
                  Expanded(
                    child: TContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TIcon(
                                icon: Iconsax.status,
                                backgroundColor: Colors.amber.withValues(alpha: 0.1),
                                color: Colors.amber,
                                size: TSizes().md,
                              ),
                              SizedBox(width: TSizes().spaceBtwItems),
                              Text(TTexts.ordersStatus.tr, style: Theme.of(context).textTheme.headlineSmall),
                            ],
                          ),
                          SizedBox(height: TSizes().spaceBtwSections),
                          const OrderStatusPieChart(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
