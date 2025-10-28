import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/image_strings.dart';
import '../../../../controllers/brand/edit_brand_controller.dart';

class EditBrandForm extends StatelessWidget {
  const EditBrandForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditBrandController());

    return Obx(
      () => TFormContainer(
        isLoading: controller.isLoading.value,
        padding: EdgeInsets.all(TSizes().defaultSpace),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              SizedBox(height: TSizes().sm),
              const TTextWithIcon(text: 'Update Brand', icon: Iconsax.dcube),
              SizedBox(height: TSizes().spaceBtwSections),

              // Name Text Field
              TextFormField(
                controller: controller.name,
                validator: (value) => TValidator.validateEmptyText('Name', value),
                decoration: const InputDecoration(labelText: 'Brand Name', prefixIcon: Icon(Iconsax.dcube)),
              ),
              SizedBox(height: TSizes().spaceBtwInputFields),

              // Categories
              Text('Select Categories', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: TSizes().spaceBtwInputFields / 2),

              _chooseCategories(controller),
              SizedBox(height: TSizes().spaceBtwInputFields),
              Obx(
                () => CheckboxMenuButton(
                  value: controller.isFeatured.value,
                  onChanged: (value) => controller.isFeatured.value = value ?? false,
                  child: const Text('Featured'),
                ),
              ),
              SizedBox(height: TSizes().spaceBtwInputFields),

              // Image Uploader & Featured Checkbox
              Obx(
                () => TImageUploader(
                  width: 80,
                  height: 80,
                  image: controller.imageURL.value.isNotEmpty ? controller.imageURL.value : TImages.defaultImage,
                  imageType: controller.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
                  onIconButtonPressed: () => controller.pickImage(),
                ),
              ),
              SizedBox(height: TSizes().spaceBtwInputFields * 2),
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => controller.updateBrand(controller.brand.value),
                            child: const Text('Update'),
                          ),
                        ),
                ),
              ),
              SizedBox(height: TSizes().spaceBtwInputFields * 2),
            ],
          ),
        ),
      ),
    );
  }

  TContainer _chooseCategories(EditBrandController controller) {
    return TContainer(
      width: double.infinity,
      backgroundColor: TColors().lightBackground,
      child: Obx(() {
        controller.selectedCategories.length;
        if (controller.categoryController.isLoading.value) {
          return Column(
            children: [
              TShimmer(width: double.infinity, height: 30, radius: 55),
              SizedBox(height: TSizes().spaceBtwItems / 2),
              TShimmer(width: double.infinity, height: 30, radius: 55),
              SizedBox(height: TSizes().spaceBtwItems / 2),
              TShimmer(width: double.infinity, height: 30, radius: 55),
            ],
          );
        }

        if (controller.categoryController.allItems.isEmpty) {
          return Center(child: Text('No Categories found'));
        }

        return Wrap(
          spacing: TSizes().md,
          direction: Axis.vertical,
          children: controller.categoryController.allItems
              // Step 1: Filter parent categories (where parentId is empty or null)
              .where((category) => category.parentId.isEmpty)
              .map((parentCategory) {
            // Step 2: For each parent category, create a widget with its children
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Parent category chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.line_horizontal_3_decrease, size: 14, color: TColors().primary),
                    SizedBox(width: TSizes().spaceBtwItems / 2),
                    TChoiceChip(
                      text: parentCategory.name,
                      selected: controller.selectedCategories.map((category) => category.id).contains(parentCategory.id),
                      onSelected: (value) => controller.toggleSelection(parentCategory),
                    ),
                  ],
                ),
                // Step 3: Find child categories (where parentId matches the parent's id)
                if (controller.categoryController.allItems.any((childCategory) => childCategory.parentId == parentCategory.id))
                  Padding(
                    padding: EdgeInsets.only(left: TSizes().lg, top: TSizes().sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.circle, size: 12),
                        SizedBox(width: TSizes().spaceBtwItems / 2),
                        Wrap(
                          spacing: TSizes().sm,
                          children: controller.categoryController.allItems
                              .where((childCategory) => childCategory.parentId == parentCategory.id)
                              .map((childCategory) => TChoiceChip(
                                    text: childCategory.name,
                                    selected: controller.selectedCategories.map((category) => category.id).contains(childCategory.id),
                                    onSelected: (value) => controller.toggleSelection(childCategory),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }).toList(),
        );
      }),
    );
  }
}
