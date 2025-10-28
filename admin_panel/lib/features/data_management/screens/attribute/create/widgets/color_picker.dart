import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/attribute/create_attribute_controller.dart';

class ColorPickerCreate extends StatelessWidget {
  const ColorPickerCreate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = CreateAttributeController.instance;
    return TFormContainer(
      fullWidth: true,
      backgroundColor: TColors().lightBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Color Picker
          ColorPicker(
            portraitOnly: true,
            pickerColor: controller.pickerColor.value,
            onColorChanged: (color) => controller.pickerColor.value = color,
            displayThumbColor: false,
            hexInputBar: true,
          ),
          SizedBox(height: TSizes().spaceBtwItems),

          Center(child: ElevatedButton.icon(onPressed: () => controller.addColorToList(), icon: Icon(Iconsax.add), label: Text('Add Color'))),
          SizedBox(height: TSizes().spaceBtwSections),

          /// Display Selected Colors
          TTextWithIcon(text: TTexts.selectedColors.tr, icon: Iconsax.color_swatch),
          SizedBox(height: TSizes().spaceBtwItems),

          Obx(() => controller.selectedColors.isEmpty
              ? Text(TTexts.yourSelectedColorsWillBeDisplayedHere.tr, style: Theme.of(context).textTheme.bodyMedium)
              : SizedBox.shrink()),

          Obx(
            () => Wrap(
              spacing: TSizes().sm,
              runSpacing: TSizes().sm,
              children: controller.selectedColors
                  .map((color) => GestureDetector(
                        onLongPress: () => controller.removeColorFromList(color), // Remove color on tap
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(height: TSizes().spaceBtwItems),

          Obx(() => controller.selectedColors.isNotEmpty
              ? Text(TTexts.longPressToDeleteColor.tr, style: Theme.of(context).textTheme.labelMedium)
              : SizedBox.shrink()),
        ],
      ),
    );
  }
}
