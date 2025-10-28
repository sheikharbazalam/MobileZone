import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/order/order_detail_controller.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderDetailController.instance;

    return TContainer(
      padding: EdgeInsets.all(TSizes().defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TTextWithIcon(text: TTexts.orderItems.tr, icon: Iconsax.receipt_item),
          SizedBox(height: TSizes().spaceBtwSections),

          // Items
          Row(
            children: [
              Expanded(child: Text(TTexts.items.tr, style: Theme.of(context).textTheme.titleSmall!.apply(letterSpacingDelta: 1.2))),
              if (TDeviceUtils.isDesktopScreen(context))
                SizedBox(width: 100, child: Text(TTexts.price.tr, style: Theme.of(context).textTheme.titleSmall!.apply(letterSpacingDelta: 1.2))),
              if (TDeviceUtils.isDesktopScreen(context))
                SizedBox(width: 70, child: Text(TTexts.qty.tr, style: Theme.of(context).textTheme.titleSmall!.apply(letterSpacingDelta: 1.2))),
              SizedBox(
                width: TDeviceUtils.isDesktopScreen(context) ? 100 : null,
                child: Text(TTexts.total.tr, style: Theme.of(context).textTheme.titleSmall!.apply(letterSpacingDelta: 1.2)),
              ),
            ],
          ),
          SizedBox(height: TSizes().spaceBtwSections),

          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              itemCount: controller.order.value.itemCount,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => Column(
                children: [
                  SizedBox(height: TSizes().spaceBtwItems / 2),
                  Divider(color: TColors().lightBackground),
                  SizedBox(height: TSizes().spaceBtwItems / 2),
                ],
              ),
              itemBuilder: (_, index) {
                final item = controller.order.value.products[index];
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TImage(
                                backgroundColor: TColors().lightBackground,
                                imageType: item.image != null ? ImageType.network : ImageType.asset,
                                image: item.image ?? TImages.defaultImage,
                              ),
                              SizedBox(width: TSizes().spaceBtwItems),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: Theme.of(context).textTheme.titleMedium,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    if (item.selectedVariation != null && item.selectedVariation!.isNotEmpty)
                                      Text(item.selectedVariation!.entries.map((e) => ('${e.key} : ${e.value} ')).toString())
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (!TDeviceUtils.isDesktopScreen(context)) SizedBox(height: TSizes().spaceBtwItems / 2),
                          if (!TDeviceUtils.isDesktopScreen(context))
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Text(TTexts.priceLabel.tr),
                                    Text(
                                      item.salePrice > 0 ? '\$${item.salePrice.toStringAsFixed(1)}' : '\$${item.price.toStringAsFixed(1)}',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                                SizedBox(width: TSizes().spaceBtwItems),
                                Row(
                                  children: [
                                    Text(TTexts.quantityLabel.tr),
                                    Text(item.quantity.toString(), style: Theme.of(context).textTheme.titleMedium),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: TSizes().spaceBtwItems),

                    /// Show Only on Desktop
                    if (TDeviceUtils.isDesktopScreen(context))
                      SizedBox(
                        width: 100,
                        child: Text(
                          item.salePrice > 0 ? '\$${item.salePrice.toStringAsFixed(1)}' : '\$${item.price.toStringAsFixed(1)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),

                    if (TDeviceUtils.isDesktopScreen(context))
                      SizedBox(
                        width: 70,
                        child: Text(item.quantity.toString(), style: Theme.of(context).textTheme.bodyLarge),
                      ),

                    SizedBox(
                      width: TDeviceUtils.isDesktopScreen(context) ? 100 : null,
                      child: Text('\$${item.totalAmount.toStringAsFixed(1)}', style: Theme.of(context).textTheme.titleLarge),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: TSizes().spaceBtwSections),

          // Items Total
          Obx(
            () => TContainer(
              padding: EdgeInsets.all(TSizes().defaultSpace),
              backgroundColor: TColors().lightBackground,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: Theme.of(context).textTheme.titleLarge),
                      Text('\$${controller.order.value.calculateSubTotal().toStringAsFixed(1)}',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  SizedBox(height: TSizes().spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(TTexts.couponDiscount.tr, style: Theme.of(context).textTheme.titleLarge),
                          if (controller.order.value.coupon != null && controller.order.value.coupon!.id.isNotEmpty)
                            TContainer(
                              onTap: () => Get.toNamed(TRoutes.editCoupon,
                                  parameters: {'id': controller.order.value.coupon!.id}, arguments: controller.order.value.coupon),
                              backgroundColor: TColors().primary.withValues(alpha: 0.3),
                              padding: EdgeInsets.symmetric(vertical: TSizes().sm / 2, horizontal: TSizes().sm),
                              child: Text(controller.order.value.coupon?.code.toUpperCase() ?? 'CWTADMIN50OFF',
                                  style: Theme.of(context).textTheme.labelLarge),
                            ),
                        ],
                      ),
                      Text('-\$${controller.order.value.couponDiscountAmount}', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  SizedBox(height: TSizes().spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Point Based Discount', style: Theme.of(context).textTheme.titleLarge),
                          if (controller.order.value.pointsUsed > 0)
                            TContainer(
                              backgroundColor: TColors().primary.withValues(alpha: 0.3),
                              padding: EdgeInsets.symmetric(vertical: TSizes().sm / 2, horizontal: TSizes().sm),
                              child: Text(
                                'Points used: ${controller.order.value.pointsUsed.toString()}',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                        ],
                      ),
                      Text('-\$${controller.order.value.pointsDiscountAmount}', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  SizedBox(height: TSizes().spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Shipping', style: Theme.of(context).textTheme.titleLarge),
                      Text(
                        '\$${controller.order.value.shippingAmount.toStringAsFixed(1)}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  SizedBox(height: TSizes().spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax', style: Theme.of(context).textTheme.titleLarge),
                      Text(
                        '\$${controller.order.value.taxAmount.toStringAsFixed(1)}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  SizedBox(height: TSizes().spaceBtwItems),
                  const Divider(),
                  SizedBox(height: TSizes().spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: Theme.of(context).textTheme.titleLarge),
                      Text('\$${controller.order.value.calculateGrandTotal().toStringAsFixed(1)}',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
