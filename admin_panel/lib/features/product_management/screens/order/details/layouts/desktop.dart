import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/order/order_detail_controller.dart';
import '../widgets/order_activity.dart';
import '../widgets/order_billing_address.dart';
import '../widgets/order_customer.dart';
import '../widgets/order_shipping_address.dart';
import '../widgets/order_status.dart';
import '../widgets/order_info.dart';
import '../widgets/order_items.dart';
import '../widgets/order_transaction.dart';

class DesktopScreen extends StatelessWidget {
  const DesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderDetailController.instance;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes().defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              Obx(
                () => TBreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Order ${controller.order.value.id} Details',
                  subHeading:
                      'Payment Status is ${controller.order.value.paymentStatus.name[0].toUpperCase() + controller.order.value.paymentStatus.name.substring(1)}. '
                      'Order placed on ${controller.order.value.formattedOrderDate}.',
                  breadcrumbItems:  [TRoutes.products, TTexts.orderDetails.tr],
                ),
              ),
              SizedBox(height: TSizes().spaceBtwSections),

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side Order Information
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        // Order Info
                        OrderInfo(),
                        SizedBox(height: TSizes().spaceBtwSections),

                        // Items
                        OrderItems(),
                        SizedBox(height: TSizes().spaceBtwSections),

                        // Transactions
                        OrderTransaction()
                      ],
                    ),
                  ),
                  SizedBox(width: TSizes().spaceBtwSections),

                  // Right Side Order Orders
                  Expanded(
                    child: Column(
                      children: [
                        // Status Info
                        OrderStatusWidget(),
                        SizedBox(height: TSizes().spaceBtwSections),

                        // // Retailer Info
                        // OrderRetailerWidget(),
                        // SizedBox(height: TSizes().spaceBtwSections),

                        // Customer Info
                        OrderCustomerWidget(),
                        SizedBox(height: TSizes().spaceBtwSections),

                        // Shipping Info
                        OrderShippingAddressWidget(),
                        SizedBox(height: TSizes().spaceBtwSections),

                        // Billing Info
                        OrderBillingAddressWidget(),
                        SizedBox(height: TSizes().spaceBtwSections),

                        // Activity Info
                        OrderActivityWidget(),
                        SizedBox(height: TSizes().spaceBtwSections),
                      ],
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
