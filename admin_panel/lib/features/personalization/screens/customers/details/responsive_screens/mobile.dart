import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:t_utils/t_utils.dart';
import '../../../../../../routes/routes.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/customer_detail_controller.dart';
import '../widgets/customer_info.dart';
import '../widgets/customer_orders.dart';
import '../widgets/shipping_address.dart';

class MobileScreen extends StatelessWidget {
  const MobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerDetailController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes().defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              Obx(
                () => controller.isLoading.value
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TShimmer(width: 150, height: 25),
                          SizedBox(height: TSizes().spaceBtwItems),
                          TShimmer(width: 200, height: 25),
                        ],
                      )
                    : TBreadcrumbsWithHeading(
                        returnToPreviousScreen: true,
                        heading: controller.customer.value.fullName.isEmpty ? TTexts.customer.tr : controller.customer.value.fullName,
                        breadcrumbItems:  [TRoutes.customers,  TTexts.details.tr],
                      ),
              ),
              SizedBox(height: TSizes().spaceBtwSections),

              // Customer Info
              const CustomerInfo(),
              SizedBox(height: TSizes().spaceBtwSections),

              // Shipping Address
              const ShippingAddress(),
              SizedBox(height: TSizes().spaceBtwSections),

              // Left Side Customer Orders
              const CustomerOrders()
            ],
          ),
        ),
      ),
    );
  }
}
