import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/image_strings.dart';
import '../../../../controllers/category/category_controller.dart';
import '../../../../controllers/category/edit_category_controller.dart';

class EditCategoryForm extends StatelessWidget {
  const EditCategoryForm({super.key});

  @override
  Widget build(BuildContext context) {
    final editController = Get.put(EditCategoryController());
    Get.put(CategoryController());

    return Obx(
      () => TFormContainer(
        isLoading: editController.isLoading.value,
        padding: EdgeInsets.all(TSizes().defaultSpace),
        child: Form(
          key: editController.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              SizedBox(height: TSizes().sm),
              const TTextWithIcon(text: 'Update Category', icon: Iconsax.category_2),
              // Text('Update Category', style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: TSizes().spaceBtwSections),

              // Name Text Field
              TextFormField(
                controller: editController.name,
                validator: (value) => TValidator.validateEmptyText('Name', value),
                decoration: const InputDecoration(labelText: 'Category Name', prefixIcon: Icon(Iconsax.category)),
              ),
              SizedBox(height: TSizes().spaceBtwInputFields * 2),

              // Image Uploader & Featured Checkbox
              Obx(
                () => TImageUploader(
                  width: 80,
                  height: 80,
                  image: editController.imageURL.value.isNotEmpty ? editController.imageURL.value : TImages.defaultImage,
                  imageType: editController.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
                  onIconButtonPressed: () => editController.pickImage(),
                ),
              ),
              SizedBox(height: TSizes().spaceBtwInputFields),
              Obx(
                () => CheckboxMenuButton(
                  value: editController.isFeatured.value,
                  onChanged: (value) => editController.isFeatured.value = value ?? false,
                  child: const Text('Featured'),
                ),
              ),
              SizedBox(height: TSizes().spaceBtwInputFields * 2),
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: editController.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () => editController.updateCategory(editController.category.value), child: const Text('Update')),
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
}
