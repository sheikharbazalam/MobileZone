import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';



import 'package:t_utils/t_utils.dart';


import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../data_management/controllers/brand/brand_controller.dart';
import '../../../../controllers/banner/create_banner_controller.dart';

class BannerBrandWidget extends StatelessWidget {
  const BannerBrandWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get instances of controllers
    final controller = Get.put(CreateBannerController());
    final brandController = Get.put(BrandController());

    return TContainer(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Retailer label
          Text(TTexts.selectBrand.tr, style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: TSizes().spaceBtwItems / 2),

          // TextField for input
          TextFormField(
            controller: brandController.searchTextField,
            onChanged: (query) => brandController.searchBrands(query),
            decoration: InputDecoration(labelText: TTexts.searchBrands.tr, prefixIcon: Icon(Icons.search)),
          ),
          SizedBox(height: TSizes().spaceBtwItems),

          // Obx to reactively show search results
          Obx(() {
            if (brandController.isLoading.value) {
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

            return Obx(
              () => ListView.separated(
                shrinkWrap: true,
                itemCount: brandController.searchResult.length,
                separatorBuilder: (_, __) => SizedBox(height: TSizes().spaceBtwItems),
                itemBuilder: (context, index) {
                  final brand = brandController.searchResult[index];
                  return Obx(
                    () => InkWell(
                      onTap: () {
                        controller.selectedBrand.value = brand;
                        brandController.searchResult.value = [];
                      },
                      child: TContainer(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: controller.selectedBrand.value.id == brand.id ? TColors().lightBackground : TColors().grey,
                        child: ListTile(
                          leading: TImage(
                            borderRadius: 0,
                            imageType: brand.imageURL.isNotEmpty ? ImageType.network : ImageType.asset,
                            image: brand.imageURL.isNotEmpty ? brand.imageURL : TImages.defaultImage,
                          ),
                          title: Text(brand.name),
                          trailing: controller.selectedBrand.value.id == brand.id
                              ? Icon(CupertinoIcons.checkmark_circle_fill, color: TColors().primary)
                              : const Icon(CupertinoIcons.circle),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          Obx(() {
            if (controller.selectedBrand.value.id.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TTextWithIcon(text: TTexts.selectedItem.tr, icon: Iconsax.tick_circle),
                  SizedBox(height: TSizes().sm),
                  SizedBox(height: TSizes().spaceBtwItems/2),
                  TContainer(
                    backgroundColor: TColors().lightBackground,
                    child: ListTile(
                        leading: TImage(
                          borderRadius: 0,
                          imageType: controller.selectedBrand.value.imageURL.isNotEmpty ? ImageType.network : ImageType.asset,
                          image: controller.selectedBrand.value.imageURL.isNotEmpty
                              ? controller.selectedBrand.value.imageURL
                              : TImages.defaultImage,
                        ),
                        title: Text(controller.selectedBrand.value.name),
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
