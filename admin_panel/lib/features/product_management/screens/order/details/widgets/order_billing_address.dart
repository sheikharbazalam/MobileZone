import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/order/order_detail_controller.dart';

class OrderBillingAddressWidget extends StatelessWidget {
  const OrderBillingAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderDetailController.instance;

    return TContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TTextWithIcon(text: TTexts.billingAddress.tr, icon: Iconsax.home),
          SizedBox(height: TSizes().spaceBtwItems),
          Obx(
            () => controller.order.value.billingAddressSameAsShipping
                ? TContainer(
                    backgroundColor: TColors().lightBackground,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(TTexts.billingAddressSameAsShipping.tr,
                              style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis, maxLines: 2),
                        ),
                      ],
                    ),
                  )
                : TContainer(
                    backgroundColor: TColors().lightBackground,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(controller.order.value.billingAddress != null ? controller.order.value.billingAddress!.name : '',
                                style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis, maxLines: 1),
                            Text(controller.order.value.billingAddress != null ? controller.order.value.billingAddress.toString() : '',
                                overflow: TextOverflow.ellipsis, maxLines: 3),
                          ],
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
