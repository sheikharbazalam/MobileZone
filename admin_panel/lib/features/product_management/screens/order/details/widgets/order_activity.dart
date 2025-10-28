import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/order/order_detail_controller.dart';

class OrderActivityWidget extends StatelessWidget {
  const OrderActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderDetailController.instance;

    return TContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TTextWithIcon(text:  TTexts.orderActivity.tr, icon: Iconsax.activity),
          SizedBox(height: TSizes().spaceBtwItems),
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              itemCount: controller.order.value.activities.length,
              separatorBuilder: (_, __) => SizedBox(height: TSizes().spaceBtwItems),
              itemBuilder: (_, index) {
                final activity = controller.order.value.activities[index];
                return TContainer(
                  backgroundColor: TColors().lightBackground,
                  onTap: () => Get.toNamed(TRoutes.customerDetails, parameters: {'id': controller.order.value.userId}),
                  child: Row(
                    children: [
                      const Icon(Iconsax.arrow_down),
                      SizedBox(width: TSizes().spaceBtwItems / 2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(activity.activityType.name[0].toUpperCase() + activity.activityType.name.substring(1),
                                style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis, maxLines: 1),
                            Text(activity.description, overflow: TextOverflow.ellipsis, maxLines: 2),
                            SizedBox(height: TSizes().spaceBtwItems),
                            Text(
                              '${TTexts.activityPerformedBy.tr} ${activity.performedBy}, on ${activity.formattedDate}.',
                              maxLines: 3,
                              style: Theme.of(context).textTheme.labelMedium,
                            )

                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
