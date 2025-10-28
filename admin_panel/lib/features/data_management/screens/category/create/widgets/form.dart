import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../controllers/category/create_category_controller.dart';

class CreateCategoryForm extends StatelessWidget {
  const CreateCategoryForm({super.key});

  @override
  Widget build(BuildContext context) {
    final createController = Get.put(CreateCategoryController());
    return TFormContainer(
      isLoading: createController.isLoading.value,
      padding: EdgeInsets.all(TSizes().defaultSpace),
      child: Form(
        key: createController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Heading
            SizedBox(height: TSizes().sm),
            TTextWithIcon(text: 'Create new Category', icon: Iconsax.category_2),

            SizedBox(height: TSizes().spaceBtwSections),

            // Name Text Field
            TextFormField(
              controller: createController.name,
              validator: (value) => TValidator.validateEmptyText('Name', value),
              decoration: const InputDecoration(labelText: 'Category Name', prefixIcon: Icon(Iconsax.category)),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),
            Obx(
              () => CheckboxMenuButton(
                value: createController.isFeatured.value,
                onChanged: (value) => createController.isFeatured.value = value ?? false,
                child: const Text('Featured'),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

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
                        child: ElevatedButton(onPressed: () => createController.createCategory(), child: const Text('Create')),
                      ),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwSections),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed(TRoutes.createSubCategory),
                child: const Text('Want to Create a Sub Category?', overflow: TextOverflow.ellipsis, maxLines: 2),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
