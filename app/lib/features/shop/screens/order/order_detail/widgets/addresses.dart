
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../models/order_model.dart';
import 'heading_with_icon.dart';

class OrderAddresses extends StatelessWidget {
  const OrderAddresses({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      backgroundColor: TColors.borderSecondary.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          THeadingWithIcon(title: TTexts.shippingAddress.tr, icon: Iconsax.location_tick),
          const SizedBox(height: TSizes.spaceBtwItems),
          buildRow(TTexts.name.tr, order.userName, context),
          buildRow(TTexts.email.tr, order.userEmail, context),
          buildRow(TTexts.address.tr, order.shippingAddress.toString(), context),

          const SizedBox(height: TSizes.spaceBtwItems),
          const Divider(),
          const SizedBox(height: TSizes.spaceBtwItems),

          THeadingWithIcon(title: TTexts.billingAddress.tr, icon: Iconsax.location),
          const SizedBox(height: TSizes.spaceBtwItems),

          if(order.billingAddressSameAsShipping)
            Text(TTexts.billingAddressSubTitle.tr),
          if(!order.billingAddressSameAsShipping) buildRow(TTexts.name.tr, order.userName, context),
          if(!order.billingAddressSameAsShipping) buildRow(TTexts.email.tr, order.userEmail, context),
          if(!order.billingAddressSameAsShipping) buildRow(TTexts.address.tr, order.shippingAddress.toString(), context),
        ],
      ),
    );
  }

  Widget buildRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Add vertical space between rows
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Expanded(
            flex: 3,
            child: Text(value, textAlign: TextAlign.right, style: Theme.of(context).textTheme.titleSmall),
          ),
        ],
      ),
    );
  }
}
