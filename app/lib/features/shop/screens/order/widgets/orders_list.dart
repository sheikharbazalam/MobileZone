import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../../home_menu.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/cloud_helper_functions.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/product/order_controller.dart';

class TOrderListItems extends StatelessWidget {
  const TOrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    return FutureBuilder(
        future: controller.fetchUserOrders(),
        builder: (_, snapshot) {
          /// Nothing Found Widget
          final emptyWidget = TAnimationLoaderWidget(
            text:TTexts.whoopsNoOrder.tr,
            animation: TImages.orderCompletedAnimation,
            showAction: true,
            actionText: TTexts.letsFillIt.tr,
            onActionPressed: () => Get.off(() => const HomeMenu()),
          );

          /// Helper Function: Handle Loader, No Record, OR ERROR Message
          final response = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, nothingFound: emptyWidget);
          if (response != null) return response;

          /// Congratulations 🎊 Record found.
          final orders = snapshot.data!;
          return ListView.separated(
            shrinkWrap: true,
            itemCount: orders.length,
            separatorBuilder: (_, index) => const SizedBox(height: TSizes.spaceBtwItems),
            itemBuilder: (_, index) {
              final order = orders[index];
              return TRoundedContainer(
                showBorder: true,
                backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.dark : TColors.light,
                child: Column(
                  children: [
                    /// -- Top Row
                    Row(
                      children: [
                        /// 1 - Image
                        const Icon(Iconsax.ship),
                        const SizedBox(width: TSizes.spaceBtwItems / 2),

                        /// 2 - Status & Date
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.orderStatus.name[0].toUpperCase() + order.orderStatus.name.substring(1),
                                overflow: TextOverflow.ellipsis,
                                style:
                                    Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.primary, fontWeightDelta: 1),
                              ),
                              Text(order.formattedOrderDateTime, style: Theme.of(context).textTheme.headlineSmall),
                            ],
                          ),
                        ),

                        /// 3 - Icon
                        IconButton(onPressed: () => Get.toNamed(TRoutes.orderDetail, arguments: order), icon: const Icon(Iconsax.arrow_right_34, size: TSizes.iconSm)),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /// -- Bottom Row
                    Row(
                      children: [
                        /// Order No
                        Expanded(
                          child: Row(
                            children: [
                              /// 1 - Icon
                              const Icon(Iconsax.tag),
                              const SizedBox(width: TSizes.spaceBtwItems / 2),

                              /// Order
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      TTexts.order.tr,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                    Text(
                                      order.id,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Delivery Date
                        Expanded(
                          child: Row(
                            children: [
                              /// 1 - Icon
                              const Icon(Iconsax.calendar),
                              const SizedBox(width: TSizes.spaceBtwItems / 2),

                              /// Status & Date
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      TTexts.shippingDate.tr,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                    Text(
                                      order.formattedDate,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
