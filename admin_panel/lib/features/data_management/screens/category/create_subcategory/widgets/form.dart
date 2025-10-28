import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../controllers/category/category_controller.dart';
import '../../../../controllers/category/create_category_controller.dart';
import '../../../../models/category_model.dart';

class CreateSubCategoryForm extends StatelessWidget {
  const CreateSubCategoryForm({super.key});

  @override
  Widget build(BuildContext context) {
    final createController = Get.put(CreateCategoryController());
    final categoryController = Get.put(CategoryController());
    return TFormContainer(
      isLoading: createController.isLoading.value,
      padding: EdgeInsets.all(TSizes().defaultSpace),
      child: Form(
        key: createController.subCategoryFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Heading
             SizedBox(height: TSizes().sm),
            TTextWithIcon(text: 'Create new Sub Category', icon: Iconsax.category5),
            SizedBox(height: TSizes().spaceBtwSections),

            // Name Text Field
            TextFormField(
              controller: createController.name,
              validator: (value) => TValidator.validateEmptyText('Name', value),
              decoration: const InputDecoration(labelText: 'Category Name', prefixIcon: Icon(Iconsax.category)),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            // Parent Categories
            Obx(
              () => categoryController.isLoading.value
                  ? const TShimmer(width: double.infinity, height: 55)
                  : DropdownButtonFormField<CategoryModel>(
                      decoration: const InputDecoration(
                        hintText: 'Parent Category',
                        labelText: 'Parent Category',
                        prefixIcon: Icon(Iconsax.bezier),
                      ),
                      onChanged: (newValue) => createController.selectedParent.value = newValue!,
                      items: categoryController.allItems
                          .where((item) => item.parentId.isEmpty)
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(item.name)]),
                            ),
                          )
                          .toList(),
                    ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            Obx(
              () => CheckboxMenuButton(
                value: createController.isFeatured.value,
                onChanged: (value) => createController.isFeatured.value = value ?? false,
                child: const Text('Featured'),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),

            // Image Uploader & Featured Checkbox
            Obx(
              () => TImageUploader(
                width: 80,
                height: 80,
                image: createController.imageURL.value.isNotEmpty ? createController.imageURL.value : TImages.defaultImage,
                imageType: createController.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
                onIconButtonPressed: () => createController.pickImage(),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: createController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () => createController.createSubCategory(), child: const Text('Create')),
                      ),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwSections),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed(TRoutes.createCategory),
                child: const Text('Want to Create Category?', overflow: TextOverflow.ellipsis, maxLines: 2),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
