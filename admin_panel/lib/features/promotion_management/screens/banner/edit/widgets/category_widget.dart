import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../data_management/controllers/category/category_controller.dart';
import '../../../../controllers/banner/edit_banner_controller.dart';

class BannerCategoryWidget extends StatelessWidget {
  const BannerCategoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get instances of controllers
    final controller = Get.put(EditBannerController());
    final categoryController = Get.put(CategoryController());

    return TContainer(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Retailer label
          Text(TTexts.chooseCategories.tr, style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: TSizes().spaceBtwItems / 2),

          // TextField for input
          Text(TTexts.addSearchKeyword.tr, style: Theme.of(context).textTheme.labelMedium),
          SizedBox(height: TSizes().sm),

          // TextField for input
          TextFormField(
            controller: categoryController.searchTextField,
            onChanged: (query) => categoryController.searchCategories(query),
            decoration:  InputDecoration(labelText: TTexts.searchCategories.tr, prefixIcon: Icon(Icons.search)),
          ),
          SizedBox(height: TSizes().spaceBtwItems),

          // Obx to reactively show search results
          Obx(() {
            if (categoryController.isLoading.value) {
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
                itemCount: categoryController.searchResult.length,
                separatorBuilder: (_, __) => SizedBox(height: TSizes().spaceBtwItems),
                itemBuilder: (context, index) {
                  final category = categoryController.searchResult[index];
                  return Obx(
                    () => InkWell(
                      onTap: () {
                        controller.selectedCategory.value = category;
                        categoryController.searchResult.value = [];
                      },
                      child: TContainer(
                        backgroundColor: controller.selectedCategory.value.id == category.id ? TColors().lightBackground : TColors().grey,
                        padding: const EdgeInsets.all(0),
                        child: ListTile(
                          leading: TImage(
                            borderRadius: 0,
                            imageType: category.imageURL.isNotEmpty ? ImageType.network : ImageType.asset,
                            image: category.imageURL.isNotEmpty ? category.imageURL : TImages.defaultImage,
                          ),
                          title: Text(category.name),
                          trailing: controller.selectedCategory.value.id == category.id
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
            if (controller.selectedCategory.value.id.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TTextWithIcon(text: TTexts.selectedItem.tr, icon: Iconsax.tick_circle),
                  SizedBox(height: TSizes().sm),
                  TContainer(
                    backgroundColor: TColors().lightBackground,
                    child: ListTile(
                        leading: TImage(
                          borderRadius: 0,
                          imageType: controller.selectedCategory.value.imageURL.isNotEmpty ? ImageType.network : ImageType.asset,
                          image: controller.selectedCategory.value.imageURL.isNotEmpty
                              ? controller.selectedCategory.value.imageURL
                              : TImages.defaultImage,
                        ),
                        title: Text(controller.selectedCategory.value.name),
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
