import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../product_management/controllers/product/product_controller.dart';
import '../../../../controllers/banner/create_banner_controller.dart';

class BannerProductsWidget extends StatelessWidget {
  const BannerProductsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get instances of controllers
    final controller = Get.put(CreateBannerController());
    final productController = Get.put(ProductController());

    return TContainer(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Retailer label
          Text(TTexts.product.tr, style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: TSizes().spaceBtwItems / 2),

          // TextField for input
          Text(TTexts.addSearchKeyword.tr, style: Theme.of(context).textTheme.labelMedium),
          SizedBox(height: TSizes().sm),
          TextFormField(
            controller: productController.searchTextField,
            onFieldSubmitted: (query) async => await productController.searchProducts(query),
            decoration: InputDecoration(
                labelText: TTexts.searchProducts.tr, prefixIcon: Icon(Icons.search), hintText: 'Add Search Keyword and Press Enter to Search'),
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

            return ListView.separated(
              shrinkWrap: true,
              itemCount: productController.searchResult.length,
              separatorBuilder: (_, __) => SizedBox(height: TSizes().spaceBtwItems),
              itemBuilder: (context, index) {
                final product = productController.searchResult[index];
                return Obx(
                  () => InkWell(
                    onTap: () {
                      controller.selectedProduct.value = product;
                      print('------------- ${product.id}');
                      // productController.searchResult.value = [];
                    },
                    child: TContainer(
                      backgroundColor: controller.selectedProduct.value.id == product.id ? TColors().lightBackground : TColors().grey,
                      padding: const EdgeInsets.all(0),
                      child: ListTile(
                        leading: TImage(
                          imageType: product.thumbnail.isNotEmpty ? ImageType.network : ImageType.asset,
                          image: product.thumbnail.isNotEmpty ? product.thumbnail : TImages.defaultImage,
                        ),
                        title: Text(product.title),
                        trailing: controller.selectedProduct.value.id == product.id
                            ? Icon(CupertinoIcons.checkmark_circle_fill, color: TColors().primary)
                            : const Icon(CupertinoIcons.circle),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          SizedBox(height: TSizes().spaceBtwSections),

          Obx(() {
            if (controller.selectedProduct.value.id.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TTextWithIcon(text: TTexts.selectedItem.tr, icon: Iconsax.tick_circle),
                  SizedBox(height: TSizes().sm),
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
