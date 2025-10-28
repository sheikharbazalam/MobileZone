import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/order/order_detail_controller.dart';

class OrderTransaction extends StatelessWidget {
  const OrderTransaction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OrderDetailController.instance;
    return TContainer(
      padding: EdgeInsets.all(TSizes().defaultSpace),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TTextWithIcon(text: '${TTexts.orderTransaction.tr} (${controller.order.value.paymentMethodType.name.toUpperCase()})', icon: Iconsax.transaction_minus),
            SizedBox(height: TSizes().spaceBtwSections),

            // Adjust as per your needs
            if (TDeviceUtils.isDesktopScreen(context))
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(TTexts.status.tr, style: Theme.of(context).textTheme.labelMedium),
                        Obx(() =>
                            Text(controller.order.value.paymentStatus.name.toUpperCase(), style: Theme.of(context).textTheme.bodyLarge)),
                      ],
                    ),
                  ),
                  if (controller.order.value.paymentMethodId != null)
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(TTexts.paymentMethodId.tr, style: Theme.of(context).textTheme.labelMedium),
                          Obx(() => Text(controller.order.value.paymentMethodId ?? '', style: Theme.of(context).textTheme.bodyLarge)),
                        ],
                      ),
                    ),
                  if (controller.order.value.paymentIntentId != null)
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(TTexts.paymentIntentId.tr, style: Theme.of(context).textTheme.labelMedium),
                          Obx(() => Text(
                                controller.order.value.paymentIntentId ?? '',
                                style: Theme.of(context).textTheme.bodyLarge,
                              )),
                        ],
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(TTexts.date.tr, style: Theme.of(context).textTheme.labelMedium),
                        Obx(() => Text(controller.order.value.formattedDate, style: Theme.of(context).textTheme.bodyLarge)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(TTexts.total.tr, style: Theme.of(context).textTheme.labelMedium),
                        Obx(() => Text('\$${controller.order.value.amountCaptured}',
                            style: Theme.of(context).textTheme.bodyLarge)),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                spacing: TSizes().spaceBtwItems,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TTexts.status.tr, style: Theme.of(context).textTheme.labelMedium),
                      Obx(() =>
                          Text(controller.order.value.paymentStatus.name.toUpperCase(), style: Theme.of(context).textTheme.bodyLarge)),
                    ],
                  ),
                  if (controller.order.value.paymentMethodId != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(TTexts.paymentMethodId.tr, style: Theme.of(context).textTheme.labelMedium),
                        Obx(() => Text(controller.order.value.paymentMethodId ?? '', style: Theme.of(context).textTheme.bodyLarge)),
                      ],
                    ),
                  if (controller.order.value.paymentIntentId != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(TTexts.paymentIntentId.tr, style: Theme.of(context).textTheme.labelMedium),
                        Obx(() => Text(
                              controller.order.value.paymentIntentId ?? '',
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                      ],
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TTexts.date.tr, style: Theme.of(context).textTheme.labelMedium),
                      Obx(() => Text(controller.order.value.formattedDate, style: Theme.of(context).textTheme.bodyLarge)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TTexts.total.tr, style: Theme.of(context).textTheme.labelMedium),
                      Obx(() => Text('\$${controller.order.value.amountCaptured}',
                          style: Theme.of(context).textTheme.bodyLarge)),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
