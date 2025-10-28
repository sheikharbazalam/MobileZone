import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';


import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/attribute/create_attribute_controller.dart';
import 'color_picker.dart';

class CreateAttributeForm extends StatelessWidget {
  const CreateAttributeForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateAttributeController());
    return TFormContainer(
      isLoading: controller.isLoading.value,
      padding: EdgeInsets.all(TSizes().defaultSpace),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Heading
            SizedBox(height: TSizes().sm),
            TTextWithIcon(text: TTexts.createNewAttribute.tr, icon: Iconsax.activity),
            SizedBox(height: TSizes().spaceBtwSections),

            // Name Text Field
            TextFormField(
              controller: controller.name,
              validator: (value) => TValidator.validateEmptyText(TTexts.name.tr, value),
              decoration: InputDecoration(
                labelText: TTexts.attributeName.tr,
                prefixIcon: Icon(Iconsax.category),
                suffixIcon: Tooltip(
                  message:
                  TTexts.attributeNameTooltip.tr,
                  child: Icon(Iconsax.info_circle, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            /// Checkbox to toggle Color Field mode
            Obx(
              () => CheckboxMenuButton(
                value: controller.isColorAttribute.value,
                onChanged: (value) => controller.isColorAttribute.value = value ?? false,
                trailingIcon: Tooltip(
                  message: TTexts.isThisAColorFieldTooltip.tr,
                  child: Icon(Iconsax.info_circle, color: Colors.grey),
                ),
                child: Text(TTexts.isThisAColorField.tr),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            /// Attribute Values Input Section
            Text(TTexts.attributeValues.tr, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: TSizes().spaceBtwInputFields / 2),

            Obx(() {
              if (controller.isColorAttribute.value) {
                return ColorPickerCreate();
              } else {
                return SizedBox(
                  height: 80,
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    textAlign: TextAlign.start,
                    controller: controller.attributeValues,
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.top,
                    validator: (value) => TValidator.validateEmptyText(TTexts.modelsField.tr, value),
                    decoration: InputDecoration(
                      labelText: TTexts.attributeValues.tr,
                      hintText: TTexts.attributeValuesHint.tr,
                      alignLabelWithHint: true,
                      suffixIcon: Tooltip(
                        message:
                        TTexts.attributeValuesTooltip.tr,
                        child: Icon(Iconsax.info_circle, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              }
            }),
            SizedBox(height: TSizes().spaceBtwInputFields),

            // Checkbox
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => CheckboxMenuButton(
                      value: controller.isSearchable.value,
                      onChanged: (value) => controller.isSearchable.value = value ?? false,
                      trailingIcon: Tooltip(
                        message:
                        TTexts.searchableTooltip.tr,
                        child: Icon(Iconsax.info_circle, color: Colors.grey),
                      ),
                      child: Text(TTexts.searchable.tr),
                    ),
                  ),
                ),

                SizedBox(width: TSizes().spaceBtwInputFields),

                // Checkbox
                Expanded(
                  child: Obx(
                    () => CheckboxMenuButton(
                      value: controller.isFilterable.value,
                      onChanged: (value) => controller.isFilterable.value = value ?? false,
                      trailingIcon: Tooltip(
                        message:
                      TTexts.sortableTooltip.tr,
                        child: Icon(Iconsax.info_circle, color: Colors.grey),
                      ),
                      child: Text(TTexts.sortable.tr),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),

            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () => controller.createAttribute(), child: Text(TTexts.create.tr)),
                      ),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
