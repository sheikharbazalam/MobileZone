import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../data_management/controllers/attribute/attribute_controller.dart';
import '../../../../../data_management/models/attribute_model.dart';
import '../../../../controllers/product/create_product_controller.dart';
import '../../../../controllers/product/product_attributes_controller.dart';
import '../../../../controllers/product/product_variations_controller.dart';

class ProductAttributes extends StatelessWidget {
  ProductAttributes({
    super.key,
  });

  // Controllers
  final attributeController = Get.put(ProductAttributesController());
  final variationController = Get.put(ProductVariationController());

  @override
  Widget build(BuildContext context) {
    final productController = CreateProductController.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider based on product type
        Obx(() =>
            productController.productType.value == ProductType.simple ? Divider(color: TColors().lightBackground) : SizedBox.shrink()),
        Obx(() =>
            productController.productType.value == ProductType.simple ? SizedBox(height: TSizes().spaceBtwSections) : SizedBox.shrink()),

        TTextWithIcon(text: TTexts.productAttributes.tr, icon: Iconsax.layer),
        SizedBox(height: TSizes().spaceBtwItems),

        // Form to add new attribute
        Form(
          key: attributeController.attributesFormKey,
          child: TDeviceUtils.isDesktopScreen(context)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildAttributeName(context, attributeController)),
                    SizedBox(width: TSizes().spaceBtwItems),
                    Expanded(flex: 2, child: _buildAttributes(attributeController)),
                    SizedBox(width: TSizes().spaceBtwItems),
                    _buildAddAttributeButton(attributeController),
                  ],
                )
              : Column(
                  children: [
                    _buildAttributeName(context, attributeController),
                    SizedBox(height: TSizes().spaceBtwItems),
                    _buildAttributes(attributeController),
                    SizedBox(height: TSizes().spaceBtwItems),
                    _buildAddAttributeButton(attributeController),
                  ],
                ),
        ),
        SizedBox(height: TSizes().spaceBtwSections),

        // List of added attributes
        Text(TTexts.allAttributes.tr, style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: TSizes().spaceBtwItems),

        // Display added attributes in a rounded container
        TContainer(
          backgroundColor: TColors().lightBackground,
          child: Obx(
            () => attributeController.productAttributes.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    itemCount: attributeController.productAttributes.length,
                    separatorBuilder: (_, __) => SizedBox(height: TSizes().spaceBtwItems),
                    itemBuilder: (_, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: TColors().white,
                          borderRadius: BorderRadius.circular(TSizes().borderRadiusLg),
                        ),
                        child: ListTile(
                          leading: const Icon(Iconsax.archive_tick),
                          title: Text(attributeController.productAttributes[index].name),
                          subtitle: attributeController.productAttributes[index].isColorAttribute
                              ? Wrap(
                                  spacing: TSizes().sm,
                                  runSpacing: TSizes().sm,
                                  children: attributeController.productAttributes[index].values.map((e) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: TContainer(
                                        width: 30,
                                        height: 30,
                                        circular: true,
                                        padding: EdgeInsets.all(2),
                                        backgroundColor: THelperFunctions.restoreColorFromValue(e),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : Text(attributeController.productAttributes[index].values.map((e) => e.trim()).toString()),
                          trailing: IconButton(
                            onPressed: () => attributeController.removeAttribute(index, context),
                            icon: Icon(Iconsax.trash, color: TColors().error),
                          ),
                        ),
                      );
                    },
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TImage(width: 150, height: 80, imageType: ImageType.asset, image: TImages.defaultAttributeColorsImageIcon),
                        ],
                      ),
                      SizedBox(height: TSizes().spaceBtwItems),
                      Text(TTexts.noAttributesAdded.tr),
                    ],
                  ),
          ),
        ),

        SizedBox(height: TSizes().spaceBtwSections),

        // Generate Variations Button
        Obx(
          () => productController.productType.value == ProductType.variable &&
                  variationController.productVariations.isEmpty &&
                  attributeController.productAttributes.isNotEmpty
              ? Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Iconsax.activity),
                    label: Text(TTexts.generateVariationsTitle.tr),
                    onPressed: () => variationController.generateVariationsConfirmation(context),
                  ),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }

  // Build text form field for attribute name
  Widget _buildAttributeName(BuildContext context, ProductAttributesController controller) {
    return Obx(() {
      // Show loading shimmer effect while attributes are loading
      if (controller.isLoading.value) return const TShimmer(width: double.infinity, height: 50);

      // Get active attributes from controller
      final allActiveAttributes = AttributeController.instance.allItems.where((item) => item.isActive).toList();

      // If no attributes are found, show message
      if (allActiveAttributes.isEmpty) {
        return ListTile(
          onTap: () => Get.toNamed(TRoutes.createAttribute),
          leading: Icon(Iconsax.tick_circle, color: TColors().primary),
          title:  Text(TTexts.noAttributesFound.tr),
          subtitle: Text(TTexts.addAttributesPrompt.tr),
        );
      }

      final allRemainingAttributes =
          allActiveAttributes.where((item) => !controller.productAttributes.map((i) => i.name).contains(item.name));

      // If no attributes are found, show message
      if (allRemainingAttributes.isEmpty) {
        return ListTile(leading: Icon(Iconsax.tick_circle, color: TColors().primary), title: Text('All Attributes Added.'));
      }

      return DropdownButtonFormField<AttributeModel>(
        decoration: InputDecoration(labelText: TTexts.selectAttribute.tr, border: OutlineInputBorder()),
        value: controller.selectedAttribute.value.id.isNotEmpty ? controller.selectedAttribute.value : null, // Show current selection
        items: allRemainingAttributes.map((attribute) {
          return DropdownMenuItem<AttributeModel>(value: attribute, child: Text(attribute.name));
        }).toList(),
        onChanged: (attribute) {
          if (attribute != null && attribute.id.isNotEmpty) {
            // Update selected attribute in the controller
            controller.selectedAttribute.value = attribute;
          }
        },
      );
    });
  }

  // Build text form field for attribute values
  Widget _buildAttributes(ProductAttributesController controller) {
    return Obx(() {
      // Ensure that the selectedAttribute has attribute values
      final attributeValues = controller.selectedAttribute.value.attributeValues;

      if (attributeValues.isNotEmpty) {
        return TContainer(
          backgroundColor: TColors().lightBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TTexts.chooseAttributeValues.tr),
              SizedBox(height: TSizes().spaceBtwItems / 2),
              Wrap(
                spacing: TSizes().sm,
                children: attributeValues
                    .map((value) => Obx(() {
                          final isSelected = controller.selectedAttributeValues.contains(value);
                          return TChoiceChip(
                            text: value,
                            selected: isSelected,
                            onSelected: (selected) => controller.toggleAttributeValue(value),
                            isColorAttribute: controller.selectedAttribute.value.isColorAttribute,
                          );
                        }))
                    .toList(),
              ),
            ],
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  // Build button to add a new attribute
  Widget _buildAddAttributeButton(ProductAttributesController controller) {
    return Obx(() => controller.selectedAttribute.value.attributeValues.isNotEmpty
        ? ElevatedButton.icon(
            onPressed: () => controller.addNewAttribute(),
            icon: const Icon(Iconsax.add),
            label: Text(TTexts.addAttribute.tr),
          )
        : SizedBox.shrink());
  }
}
