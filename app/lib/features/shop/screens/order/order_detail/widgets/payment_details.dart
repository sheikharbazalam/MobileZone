import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../models/order_model.dart';
import 'heading_with_icon.dart';

class PaymentDetail extends StatelessWidget {
  const PaymentDetail({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      backgroundColor: TColors.borderSecondary.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          THeadingWithIcon(title: TTexts.paymentDetails.tr, icon: Iconsax.bank),
          const SizedBox(height: TSizes.spaceBtwItems),

          buildRow("${TTexts.subTotal.tr} (${order.itemCount} items):", "\$${order.totalAmount}", context),

          buildRow(TTexts.deliveryFee.tr, "\$${order.shippingAmount}", context),
          buildRow(TTexts.taxAmount.tr, "\$${order.taxAmount}", context),
          const Divider(thickness: 1.0),
          buildRow(TTexts.total.tr, "\$${order.totalAmount}", context),
          const SizedBox(height: TSizes.xs),
          buildRow(TTexts.paymentMethod.tr, TTexts.cashOnDelivery.tr, context),
        ],
      ),
    );
  }

  Widget buildRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Add vertical space between rows
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.right),
        ],
      ),
    );
  }
}
