import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/customer_detail_controller.dart';

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = CustomerDetailController.instance;
    return TContainer(
      padding: EdgeInsets.all(TSizes().defaultSpace),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TTextWithIcon(text: TTexts.customerInformation.tr, icon: Iconsax.information),
            SizedBox(height: TSizes().spaceBtwSections),

            // Personal Info Card
            Row(
              children: [
                TImage(
                  padding: 0,
                  backgroundColor: TColors().lightBackground,
                  image: controller.customer.value.profilePicture.isNotEmpty ? controller.customer.value.profilePicture : TImages.user,
                  imageType: controller.customer.value.profilePicture.isNotEmpty ? ImageType.network : ImageType.asset,
                ),
                SizedBox(width: TSizes().spaceBtwItems),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(controller.customer.value.fullName,
                          style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis, maxLines: 1),
                      Text(controller.customer.value.email, overflow: TextOverflow.ellipsis, maxLines: 1),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: TSizes().spaceBtwSections),

            // Meta Data
            Row(
              children: [
                SizedBox(width: 120, child: Text(TTexts.emailVerified.tr)),
                SizedBox(width: TSizes().spaceBtwItems / 2),
                Expanded(
                  child: TContainer(
                    padding: EdgeInsets.symmetric(vertical: TSizes().sm, horizontal: TSizes().md),
                    backgroundColor:
                        controller.customer.value.isEmailVerified ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
                    child: Text(
                      controller.customer.value.isEmailVerified ? TTexts.verified.tr : TTexts.notVerified.tr,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .apply(color: controller.customer.value.isEmailVerified ? Colors.green : Colors.red),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: TSizes().spaceBtwItems),
            Row(
              children: [
                SizedBox(width: 120, child: Text(TTexts.verificationStatus.tr)),
                SizedBox(width: TSizes().spaceBtwItems / 2),
                Expanded(
                  child: TContainer(
                    padding: EdgeInsets.symmetric(vertical: TSizes().sm, horizontal: TSizes().md),
                    backgroundColor:
                        THelperFunctions.getVerificationStatusColor(controller.customer.value.verificationStatus).withValues(alpha: 0.2),
                    child: Text(
                      controller.customer.value.verificationStatus.name[0].toUpperCase() +
                          controller.customer.value.verificationStatus.name.substring(1),
                      style: Theme.of(context).textTheme.titleMedium!.apply(
                            color: THelperFunctions.getVerificationStatusColor(controller.customer.value.verificationStatus),
                          ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: TSizes().spaceBtwItems),

            // Divider
            Divider(),
            SizedBox(height: TSizes().spaceBtwItems),

            // Additional Details
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TTexts.lastOrder.tr, style: Theme.of(context).textTheme.titleLarge),
                      if (controller.allCustomerOrders.isNotEmpty) Text(controller.allCustomerOrders.first.formattedOrderDateTime),
                      if (controller.allCustomerOrders.isEmpty)  Text(TTexts.noOrdersYet.tr),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TTexts.averageOrderValue.tr, style: Theme.of(context).textTheme.titleLarge),
                      if (controller.allCustomerOrders.isNotEmpty)
                        Text(
                            '\$${(controller.allCustomerOrders.fold<double>(0, (previous, order) => previous + (order.calculateGrandTotal())) / controller.allCustomerOrders.length).toStringAsFixed(1)}'),
                      if (controller.allCustomerOrders.isEmpty)  Text(TTexts.noOrdersYet.tr),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: TSizes().spaceBtwItems),

            // Additional Details Cont.
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TTexts.registered.tr, style: Theme.of(context).textTheme.titleLarge),
                      Text(controller.customer.value.formattedDate),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TTexts.phoneNumber.tr, style: Theme.of(context).textTheme.titleLarge),
                      Text(controller.customer.value.formattedPhoneNo),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
