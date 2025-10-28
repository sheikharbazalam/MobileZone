import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/order/order_detail_controller.dart';

class OrderStatusWidget extends StatelessWidget {
  const OrderStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderDetailController.instance;

    return TContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TTextWithIcon(text:TTexts.updateStatus.tr, icon: Iconsax.cloud_change),
          SizedBox(height: TSizes().spaceBtwSections),
          Obx(
            () {
              if (controller.statusLoader.value) return const TShimmer(width: double.infinity, height: 55);
              return DropdownButtonFormField<OrderStatus>(
                padding: const EdgeInsets.symmetric(vertical: 0),
                value: controller.selectedStatus.value,
                style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.black),
                dropdownColor: Colors.white,
                decoration: InputDecoration(labelText: TTexts.updateStatus.tr, prefixIcon: Icon(Iconsax.status)),
                onChanged: (OrderStatus? newValue) {
                  if (newValue != null) controller.selectedStatus.value = newValue;
                },
                items: OrderStatus.values.map((OrderStatus status) {
                  return DropdownMenuItem<OrderStatus>(value: status, child: Text(status.name.capitalize.toString()));
                }).toList(),
              );
            },
          ),
          SizedBox(height: TSizes().spaceBtwSections),
          SizedBox(
              width: double.infinity, child: ElevatedButton(onPressed: () => controller.updateOrderStatus(), child: const Text('Update'))),
        ],
      ),
    );
  }
}
