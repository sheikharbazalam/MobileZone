import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/product/create_product_controller.dart';

class ProductTitleAndDescription extends StatelessWidget {
  const ProductTitleAndDescription({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateProductController());

    return TContainer(
      child: Form(
        key: controller.titleDescriptionFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information Text
            TTextWithIcon(text: TTexts.basicInformation.tr, icon: Iconsax.receipt_edit),
            SizedBox(height: TSizes().spaceBtwItems),

            // Product Title Input Field
            TextFormField(
              controller: controller.title,
              validator: (value) => TValidator.validateEmptyText(TTexts.productTitle.tr, value),
              decoration: InputDecoration(
                labelText: TTexts.productTitle.tr,
                prefixIcon: Icon(Iconsax.text),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            // Product Description Input Field
            TTextEditor(controller: controller.productDescriptionController),
          ],
        ),
      ),
    );
  }
}
