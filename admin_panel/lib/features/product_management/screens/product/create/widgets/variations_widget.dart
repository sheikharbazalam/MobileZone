import 'package:cwt_ecommerce_admin_panel/features/product_management/controllers/product/product_attributes_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/product/create_product_controller.dart';
import '../../../../controllers/product/product_images_controller.dart';
import '../../../../controllers/product/product_variations_controller.dart';
import '../../../../models/product_variation_model.dart';

class ProductVariations extends StatelessWidget {
  const ProductVariations({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final variationController = ProductVariationController.instance;

    return Obx(
      () => CreateProductController.instance.productType.value == ProductType.variable
          ? TContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Variations Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: TTextWithIcon(text: TTexts.productVariations.tr, icon: Iconsax.book)),
                      TextButton(
                        onPressed: () => variationController.removeVariations(context),
                        child: Text(TTexts.removeVariations.tr),
                      ),
                    ],
                  ),
                  SizedBox(height: TSizes().spaceBtwItems),

                  // Variations List
                  if (variationController.productVariations.isNotEmpty)
                    ListView.separated(
                      itemCount: variationController.productVariations.length,
                      shrinkWrap: true,
                      separatorBuilder: (_, __) => SizedBox(height: TSizes().spaceBtwItems),
                      itemBuilder: (_, index) {
                        final variation = variationController.productVariations[index];
                        return _buildVariationTile(context, index, variation, variationController);
                      },
                    )
                  else
                    _buildNoVariationsMessage(),
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }

  // Helper method to build a variation tile
  Widget _buildVariationTile(
      BuildContext context, int index, ProductVariationModel variation, ProductVariationController variationController) {
    return ExpansionTile(
      initiallyExpanded: false,
      backgroundColor: TColors().lightGrey,
      collapsedBackgroundColor: TColors().lightGrey,
      childrenPadding: EdgeInsets.all(TSizes().md),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes().borderRadiusLg),
        side: BorderSide(color: TColors().grey),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes().borderRadiusLg),
        side: BorderSide(color: TColors().grey),
      ),
      title: Row(
        spacing: TSizes().spaceBtwItems / 2,
        children: [
          const Icon(Iconsax.clipboard),
          ..._generateVariationTitle(context, variation.attributeValues.entries),
        ],
      ),
      children: [
        // Upload Variation Image
        Obx(
          () => TImageUploader(
            right: 0,
            left: null,
            imageType: variation.image.value.isNotEmpty ? ImageType.network : ImageType.asset,
            image: variation.image.value.isNotEmpty ? variation.image.value : TImages.defaultImage,
            onIconButtonPressed: () => ProductImagesController.instance.selectVariationImage(variation),
          ),
        ),
        SizedBox(height: TSizes().spaceBtwInputFields),

        // Variation Stock, and Pricing
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) => variation.stock = int.parse(value),
                decoration:  InputDecoration(
                    labelText:  TTexts.stock.tr, hintText: TTexts.addStockHint.tr, prefixIcon: Icon(Iconsax.unlimited)),
                controller: variationController.stockControllersList[index][variation],
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            SizedBox(width: TSizes().spaceBtwInputFields),
            Expanded(
              child: TextFormField(
                onChanged: (value) => variation.sku = value,
                controller: variationController.skuControllersList[index][variation],
                decoration:  InputDecoration(labelText: TTexts.sku.tr, hintText: TTexts.addSkuHint.tr, prefixIcon: Icon(Iconsax.note_add)),
              ),
            ),
            SizedBox(width: TSizes().spaceBtwInputFields),
            Expanded(
              child: TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
                ],
                onChanged: (value) => variation.price = double.parse(value),
                decoration: InputDecoration(
                    labelText: TTexts.price.tr, hintText: TTexts.priceHint.tr, prefixIcon: Icon(Iconsax.money_send)),
                controller: variationController.priceControllersList[index][variation],
              ),
            ),
            SizedBox(width: TSizes().spaceBtwInputFields),
            Expanded(
              child: TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
                ],
                onChanged: (value) => variation.salePrice = double.parse(value),
                controller: variationController.salePriceControllersList[index][variation],
                decoration: InputDecoration(
                  labelText: TTexts.discountedPrice.tr,
                  hintText: TTexts.priceHint.tr,
                  prefixIcon: Icon(Iconsax.discount_circle),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: TSizes().spaceBtwInputFields),

        // Variation Description
        TextFormField(
          onChanged: (value) => variation.description = value,
          controller: variationController.descriptionControllersList[index][variation],
          decoration: InputDecoration(
            labelText: TTexts.description.tr,
            hintText: TTexts.addVariationDescriptionHint.tr,
            prefixIcon: Icon(Iconsax.document),
          ),
        ),
        SizedBox(height: TSizes().spaceBtwSections),
      ],
    );
  }

  // Helper method to build message when there are no variations
  Widget _buildNoVariationsMessage() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TImage(width: 200, height: 200, imageType: ImageType.asset, image: TImages.defaultVariationImageIcon),
          ],
        ),
        SizedBox(height: TSizes().spaceBtwItems),
        Text(TTexts.noVariationsAdded.tr),
      ],
    );
  }

  List<Widget> _generateVariationTitle(BuildContext context, Iterable<MapEntry<String, String>> entries) {
    List<Widget> widgets = [];
    for (var entry in entries) {
      final attribute = ProductAttributesController.instance.productAttributes
          .where((pa) => pa.name.toLowerCase() == entry.key.toLowerCase())
          .firstOrNull;

      // Check if attribute is colored
      if (attribute != null && attribute.isColorAttribute) {
        Color color = THelperFunctions.restoreColorFromValue(entry.value);
        final widget = TContainer(
          showBorder: true,
          borderColor: TColors().grey,
          padding: EdgeInsets.all(TSizes().sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: TSizes().sm,
            children: [
              Text(
                '${entry.key}:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(color: Colors.black)),
                child: TContainer(width: 18, height: 18, circular: true, padding: EdgeInsets.all(2), backgroundColor: color),
              ),
            ],
          ),
        );

        widgets.add(widget);
      } else {
        final widget = TContainer(
          showBorder: true,
          borderColor: TColors().grey,
          padding: EdgeInsets.all(TSizes().sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: TSizes().sm,
            children: [
              Text('${entry.key}:', style: Theme.of(context).textTheme.bodyLarge),
              Text(entry.value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        );
        widgets.add(widget);
      }
    }

    return widgets;
  }
}
