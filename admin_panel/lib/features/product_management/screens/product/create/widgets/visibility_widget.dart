import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/product/create_product_controller.dart';

class ProductVisibilityWidget extends StatelessWidget {
  const ProductVisibilityWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateProductController());
    return TContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visibility Header
          TTextWithIcon(text: TTexts.productVisibility.tr, icon: Iconsax.lamp_on),
          SizedBox(height: TSizes().spaceBtwItems),

          // Radio buttons for product visibility
          Obx(
            () => Column(
              children: [
                _buildVisibilityRadioButton(controller, true, 'Publish'),
                _buildVisibilityRadioButton(controller, false, 'Draft'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a radio button for product visibility
  Widget _buildVisibilityRadioButton(CreateProductController controller, bool value, String label) {
    return RadioMenuButton<bool>(
      value: value,
      groupValue: controller.publishProduct.value,
      onChanged: (selection) => controller.publishProduct.value = selection ?? true,
      child: Text(label),
    );
  }
}
