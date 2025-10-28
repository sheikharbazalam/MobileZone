import 'package:cwt_ecommerce_admin_panel/features/personalization/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/product/product_controller.dart';
import '../../../../controllers/review/create_review_controller.dart';

class ProductsWidget extends StatelessWidget {
  const ProductsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get instances of controllers
    final controller = Get.put(CreateReviewController());
    final productController = Get.put(ProductController());

    return TContainer(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Retailer label
          TContainer(
            showBorder: true,
            showShadow: true,
            borderColor: TColors().lightBackground,
            backgroundColor: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(TTexts.searchProducts.tr, style: Theme.of(context).textTheme.bodyLarge),
                SizedBox(height: TSizes().spaceBtwItems),

                // TextField for input
                Obx(
                  () => productController.searchLoader.value
                      ? TShimmer(width: double.infinity, height: 55)
                      : TextFormField(
                          controller: productController.searchTextField,
                          decoration: InputDecoration(labelText: TTexts.searchProducts.tr, prefixIcon: Icon(Iconsax.filter_search)),
                          onFieldSubmitted:
                              productController.searchLoader.value ? null : (query) => productController.searchProducts(query),
                        ),
                ),
                SizedBox(height: TSizes().spaceBtwItems / 2),
                Text(
                    TTexts.searchProductsNote.tr,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(height: TSizes().spaceBtwItems),

                // Obx to reactively show search results
                Obx(() {
                  if (productController.searchLoader.value) {
                    return Column(
                      spacing: TSizes().spaceBtwItems,
                      children: const [
                        TShimmer(width: double.infinity, height: 30),
                        TShimmer(width: double.infinity, height: 30),
                        TShimmer(width: double.infinity, height: 30),
                        TShimmer(width: double.infinity, height: 30),
                        TShimmer(width: double.infinity, height: 30),
                      ],
                    );
                  }

                  return Column(
                    spacing: TSizes().spaceBtwItems,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (productController.searchResult.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(TTexts.results.tr, style: Theme.of(context).textTheme.bodyLarge),
                            TextButton(onPressed: () => productController.searchResult.value = [], child: Text(TTexts.clear.tr)),
                          ],
                        ),
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: productController.searchResult.length,
                        separatorBuilder: (_, __) => SizedBox(height: TSizes().spaceBtwItems),
                        itemBuilder: (context, index) {
                          final product = productController.searchResult[index];
                          final alreadyReviewed = UserController.instance.user.value.reviewedProducts?.contains(product.id) ?? false;
                          return Obx(() {
                            controller.selectedProduct.value.id;
                            return InkWell(
                              onTap: alreadyReviewed ? null : () => controller.selectedProduct.value = product,
                              child: TContainer(
                                backgroundColor:
                                    controller.selectedProduct.value.id == product.id ? TColors().lightBackground : TColors().grey,
                                padding: const EdgeInsets.all(0),
                                child: ListTile(
                                  leading: TImage(
                                    imageType: product.thumbnail.isNotEmpty ? ImageType.network : ImageType.asset,
                                    image: product.thumbnail.isNotEmpty ? product.thumbnail : TImages.defaultImage,
                                  ),
                                  title: Text(
                                    product.title,
                                    style: TextStyle(
                                      decoration: alreadyReviewed ? TextDecoration.lineThrough : TextDecoration.none,
                                      color: alreadyReviewed ? Colors.grey : null,
                                    ),
                                  ),
                                  subtitle: alreadyReviewed ? Text(TTexts.productToReview.tr) : null,
                                  trailing: alreadyReviewed
                                      ? Icon(CupertinoIcons.checkmark_circle_fill, color: TColors().lightGrey)
                                      : controller.selectedProduct.value.id == product.id
                                          ? Icon(CupertinoIcons.checkmark_circle_fill, color: TColors().primary)
                                          : const Icon(CupertinoIcons.circle),
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),

          SizedBox(height: TSizes().spaceBtwItems),
          Divider(),
          SizedBox(height: TSizes().spaceBtwItems),

          Obx(() {
            if (controller.selectedProduct.value.id.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TTextWithIcon(text: 'Product to review', icon: Iconsax.tick_circle),
                  SizedBox(height: TSizes().spaceBtwItems),
                  TContainer(
                    backgroundColor: TColors().lightBackground,
                    child: ListTile(
                        leading: TImage(
                          imageType: controller.selectedProduct.value.thumbnail.isNotEmpty ? ImageType.network : ImageType.asset,
                          image: controller.selectedProduct.value.thumbnail.isNotEmpty
                              ? controller.selectedProduct.value.thumbnail
                              : TImages.defaultImage,
                        ),
                        title: Text(controller.selectedProduct.value.title),
                        trailing: Icon(CupertinoIcons.checkmark_circle_fill, color: TColors().primary)),
                  ),
                ],
              );
            }

            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
