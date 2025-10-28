import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/product/edit_product_controller.dart';

class ProductTag extends StatelessWidget {
  const ProductTag({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get instances of controllers
    final controller = Get.put(EditProductController());

    return TContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand label
          TTextWithIcon(text: TTexts.productTags.tr, icon: Iconsax.tag),
          SizedBox(height: TSizes().spaceBtwItems / 2),

          Text(
            TTexts.productTagsNote.tr,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          SizedBox(height: TSizes().spaceBtwItems),

          // Text field
          TextFormField(
            focusNode: controller.tagFocusNode,
            controller: controller.tagTextField,
            decoration: InputDecoration(
              labelText: TTexts.tags.tr,
              hintText: TTexts.addCommaSeparatedTags.tr,
              prefixIcon: Icon(Iconsax.tag_25),
            ),
            onChanged: (value) => controller.handleTextInput(value),
            onFieldSubmitted: (value) => controller.addTag(value),
          ),
          SizedBox(height: TSizes().spaceBtwItems),

          Obx(
            () => Wrap(
              spacing: TSizes().sm,
              runSpacing: TSizes().sm,
              children: controller.tags
                  .map(
                    (tag) => Chip(
                      backgroundColor: Colors.white,
                      label: Text(tag),
                      onDeleted: () => controller.removeTag(tag),
                      deleteIcon: const Icon(CupertinoIcons.clear),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
