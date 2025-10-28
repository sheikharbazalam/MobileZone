import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/order/order_detail_controller.dart';

class OrderShippingAddressWidget extends StatelessWidget {
  const OrderShippingAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderDetailController.instance;

    return TContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TTextWithIcon(text: TTexts.shippingAddress.tr, icon: Iconsax.home),
          SizedBox(height: TSizes().spaceBtwItems),
          Obx(
            () => TContainer(
              backgroundColor: TColors().lightBackground,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.order.value.shippingAddress.id.isNotEmpty ? controller.order.value.shippingAddress.name : '',
                            style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis, maxLines: 1),
                        Text(controller.order.value.shippingAddress.id.isNotEmpty ? controller.order.value.shippingAddress.toString() : '',
                            overflow: TextOverflow.ellipsis, maxLines: 3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
