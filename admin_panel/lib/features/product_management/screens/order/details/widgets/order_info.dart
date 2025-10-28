import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/order/order_detail_controller.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderDetailController.instance;

    return TContainer(
      padding: EdgeInsets.all(TSizes().defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TTextWithIcon(text:TTexts.orderInformation.tr, icon: Iconsax.information),
          SizedBox(height: TSizes().spaceBtwSections),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(TTexts.date.tr),
                    Obx(() => Text(controller.order.value.formattedOrderDateTime, style: Theme.of(context).textTheme.titleMedium)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(TTexts.items.tr),
                    Obx(() => Text('${controller.order.value.itemCount} Items', style: Theme.of(context).textTheme.titleMedium)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( TTexts.itemsCount.tr),
                    Obx(() => Text('\$${controller.order.value.calculateGrandTotal()}', style: Theme.of(context).textTheme.titleMedium)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
