import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/utils/constants/sizes.dart';

import '../../../../../../utils/constants/enums.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/product/edit_product_controller.dart';

class ProductTypeWidget extends StatelessWidget {
  const ProductTypeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = EditProductController.instance;

    return Obx(
      () => Row(
        children: [
          Text(TTexts.productType.tr, style: Theme.of(context).textTheme.titleLarge),
          SizedBox(width: TSizes().spaceBtwItems),
          // Radio button for Single Product Type
          RadioMenuButton(
            value: ProductType.simple,
            groupValue: controller.productType.value,
            onChanged: (value) {
              // Update the selected product type in the controller
              controller.productType.value = value ?? ProductType.simple;
            },
            child: Text(TTexts.single.tr),
          ),
          // Radio button for Variable Product Type
          RadioMenuButton(
            value: ProductType.variable,
            groupValue: controller.productType.value,
            onChanged: (value) {
              // Update the selected product type in the controller
              controller.productType.value = value ?? ProductType.simple;
            },
            child: Text(TTexts.variable.tr),
          ),
        ],
      ),
    );
  }
}
