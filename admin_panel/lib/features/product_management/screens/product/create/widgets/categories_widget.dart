import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../data_management/controllers/category/category_controller.dart';
import '../../../../controllers/product/create_product_controller.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get instance of the CategoryController
    final categoriesController = Get.put(CategoryController());

    // Fetch categories if the list is empty
    if (categoriesController.allItems.isEmpty) {
      categoriesController.fetchItems();
    }

    return TContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories label
          TTextWithIcon(text: TTexts.productCategories.tr, icon: Iconsax.category_2),
          SizedBox(height: TSizes().spaceBtwItems),
          Obx(() => CreateProductController.instance.selectedCategories.isNotEmpty
              ? Wrap(
                  spacing: TSizes().sm,
                  runSpacing: TSizes().sm,
                  children: CreateProductController.instance.selectedCategories
                      // .where((category) => category.parentId.isEmpty)
                      .map((parentCategory) {
                    return Chip(
                      backgroundColor: Colors.white,
                      label: Text(parentCategory.name),
                      onDeleted: () => CreateProductController.instance.selectedCategories.remove(parentCategory),
                      deleteIcon: const Icon(CupertinoIcons.clear),
                    );
                  }).toList(),
                )
              : Align(alignment: Alignment.center, child: Text(TTexts.thereAreNoCategoriesSelected.tr))),
          SizedBox(height: TSizes().spaceBtwSections),

          // Button to Add Categories
          Obx(
            () => categoriesController.isLoading.value
                ? const TShimmer(width: double.infinity, height: 50)
                : Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(onPressed: () => _chooseCategories(context), child: Text(TTexts.addCategories.tr)),
                    ),
                  ),
          ),
          SizedBox(height: TSizes().defaultSpace),
        ],
      ),
    );
  }


  void _chooseCategories(BuildContext context) {
    final categoryController = CategoryController.instance;
    TDialogs.defaultDialog(
      context: context,
      title: TTexts.chooseCategories.tr,
      confirmText: TTexts.done.tr,
      cancelText: TTexts.close.tr,
      onConfirm: () => Get.back(),
      onCancel: () => Get.back(),
      content: Obx(
            () {
          // ... loading and empty states remain the same ...

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              maxWidth: 1200,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: TSizes().md,
                  children: categoryController.allItems.where((category) => category.parentId.isEmpty).map((parentCategory) {
                    return Container(
                      constraints: BoxConstraints(maxWidth: 1100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Parent category row
                          Row(
                            children: [
                              Icon(CupertinoIcons.line_horizontal_3_decrease, size: 14, color: TColors().primary),
                              SizedBox(width: TSizes().spaceBtwItems / 2),
                              TChoiceChip(
                                text: parentCategory.name,
                                selected: CreateProductController.instance.selectedCategories.contains(parentCategory),
                                onSelected: (value) => CreateProductController.instance.toggleCategories(parentCategory),
                              ),
                            ],
                          ),
                          // Child categories
                          if (categoryController.allItems.any((child) => child.parentId == parentCategory.id))
                            Padding(
                              padding: EdgeInsets.only(left: TSizes().lg, top: TSizes().sm),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    const Icon(CupertinoIcons.circle, size: 12),
                                    SizedBox(width: TSizes().spaceBtwItems / 2),
                                    Wrap(
                                      spacing: TSizes().sm,
                                      children: categoryController.allItems
                                          .where((childCategory) => childCategory.parentId == parentCategory.id)
                                          .map((childCategory) => TChoiceChip(
                                        text: childCategory.name,
                                        selected: CreateProductController.instance.selectedCategories
                                            .contains(childCategory),
                                        onSelected: (value) =>
                                            CreateProductController.instance.toggleCategories(childCategory),
                                      ))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
