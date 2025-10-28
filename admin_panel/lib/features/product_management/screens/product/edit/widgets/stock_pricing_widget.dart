import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/constants/enums.dart';


import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/product/edit_product_controller.dart';

import 'package:t_utils/t_utils.dart';

class ProductStockAndPricing extends StatelessWidget {
  const ProductStockAndPricing({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = EditProductController.instance;

    return Obx(
      () => controller.productType.value == ProductType.simple
          ? Form(
              key: controller.stockPriceFormKey,
              child: TDeviceUtils.isDesktopScreen(context)
                  ? Row(
                      children: [
                        // Stock
                        Expanded(child: _stockField(controller)),
                        SizedBox(width: TSizes().spaceBtwItems),
                        // SKU
                        Expanded(child: _skuField(controller)),
                        SizedBox(width: TSizes().spaceBtwItems),
                        // Price
                        Expanded(child: _priceField(controller)),
                        SizedBox(width: TSizes().spaceBtwItems),

                        // Sale Price
                        Expanded(child: _salePriceField(controller)),
                      ],
                    )
                  : TDeviceUtils.isTabletScreen(context)
                      ? Column(
                          children: [
                            Row(
                              children: [
                                // Stock
                                Expanded(child: _stockField(controller)),
                                SizedBox(width: TSizes().spaceBtwItems),
                                // SKU
                                Expanded(child: _skuField(controller)),
                              ],
                            ),
                            SizedBox(height: TSizes().spaceBtwItems),
                            Row(
                              children: [
                                // Price
                                Expanded(child: _priceField(controller)),
                                SizedBox(width: TSizes().spaceBtwItems),

                                // Sale Price
                                Expanded(child: _salePriceField(controller)),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            // Stock
                            _stockField(controller),
                            SizedBox(height: TSizes().spaceBtwItems),
                            // SKU
                            _skuField(controller),
                            SizedBox(height: TSizes().spaceBtwItems),
                            // Price
                            _priceField(controller),
                            SizedBox(height: TSizes().spaceBtwItems),

                            // Sale Price
                            _salePriceField(controller),
                          ],
                        ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _salePriceField(EditProductController controller) {
    return TextFormField(
      controller: controller.salePrice,
      decoration: InputDecoration(
        labelText: TTexts.discountedPrice.tr,
        hintText: TTexts.priceHint.tr,
        prefixIcon: Icon(Iconsax.discount_circle),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
      ],
    );
  }

  Widget _priceField(EditProductController controller) {
    return TextFormField(
      controller: controller.price,
      decoration: InputDecoration(labelText: TTexts.price.tr, hintText: 'Price with up-to 2 decimals', prefixIcon: Icon(Iconsax.money_send)),
      validator: (value) => TValidator.validateEmptyText(TTexts.price.tr, value),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
      ],
    );
  }

  Widget _skuField(EditProductController controller) {
    return TextFormField(
      controller: controller.sku,
      decoration: InputDecoration(labelText: TTexts.sku.tr, hintText: TTexts.addSkuHint.tr, prefixIcon: Icon(Iconsax.note_add)),
    );
  }

  Widget _stockField(EditProductController controller) {
    return TextFormField(
      controller: controller.stock,
      decoration:
      InputDecoration(labelText: TTexts.stock.tr, hintText: TTexts.addStockHint.tr, prefixIcon: Icon(Iconsax.unlimited)),
      validator: (value) => TValidator.validateEmptyText(TTexts.stock.tr, value),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
    );
  }
}
