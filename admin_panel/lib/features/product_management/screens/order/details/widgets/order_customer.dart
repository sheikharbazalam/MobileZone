import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/order/order_detail_controller.dart';

class OrderCustomerWidget extends StatelessWidget {
  const OrderCustomerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderDetailController.instance;

    return TContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TTextWithIcon(text: TTexts.customer.tr, icon: Iconsax.user_octagon),
          SizedBox(height: TSizes().spaceBtwItems),
          Obx(
            () => TContainer(
              backgroundColor: TColors().lightBackground,
              onTap: () => Get.toNamed(TRoutes.customerDetails, parameters: {'id': controller.order.value.userId}),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.order.value.userName,
                            style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis, maxLines: 1),
                        Text(controller.order.value.userEmail, overflow: TextOverflow.ellipsis, maxLines: 1),
                      ],
                    ),
                  ),
                  const Icon(Iconsax.arrow_right),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
