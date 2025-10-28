import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../controllers/unit/create_unit_controller.dart';

class CreateUnitForm extends StatelessWidget {
  const CreateUnitForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateUnitController());
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
            const TTextWithIcon(text: 'Create new Unit', icon: Iconsax.unlimited),
            SizedBox(height: TSizes().spaceBtwSections),

            // Name Text Field
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.name,
                    validator: (value) => TValidator.validateEmptyText('Unit Name', value),
                    decoration: InputDecoration(
                      labelText: 'Unit Name',
                      prefixIcon: Icon(Iconsax.unlimited),
                      suffixIcon: Tooltip(
                        message:
                            'Enter a descriptive name for the unit of measurement, such as Length, Weight, Width, or Height, to specify the type of attribute.',
                        child: Icon(Iconsax.info_circle),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: TSizes().spaceBtwInputFields),
                Expanded(
                  child: TextFormField(
                    controller: controller.abbreviation,
                    decoration: const InputDecoration(
                      labelText: 'Unit Abbreviation',
                      prefixIcon: Icon(Iconsax.check),
                      suffixIcon: Tooltip(
                        message:
                            'Provide a concise abbreviation for the unit, such as \'kg\' for kilograms or \'cm\' for centimeters, to ensure clarity and uniformity in usage.',
                        child: Icon(Iconsax.info_circle),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),
            Row(
              children: [
                Expanded(child: _customDropdown(controller)),
                SizedBox(width: TSizes().spaceBtwInputFields),
                Expanded(
                  child: TextFormField(
                    controller: controller.conversionFactor,
                    decoration: const InputDecoration(
                      labelText: 'Conversion Factor',
                      prefixIcon: Icon(Iconsax.convert),
                      suffixIcon: Tooltip(
                        message:
                            'Specify the numerical factor used to convert this unit to the base unit. For instance, if the base unit is meters, the conversion factor for centimeters would be 0.01.',
                        child: Icon(Iconsax.info_circle),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            // Categories
            Text('Searchable Keywords', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: TSizes().spaceBtwInputFields / 2),
            SizedBox(
              height: 60,
              child: TextFormField(
                expands: true,
                maxLines: null,
                textAlign: TextAlign.start,
                controller: controller.searchKeywords,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Unit Values',
                  hintText: 'Add units separated by |  Example: Small | Medium | Large',
                  alignLabelWithHint: true,
                  suffixIcon: Tooltip(
                    message:
                        'Enter a list of values representing this unit, separated by a delimiter, to define the range or options available for this attribute.',
                    child: Icon(Iconsax.info_circle),
                  ),
                ),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            // Checkbox
            Obx(
              () => CheckboxMenuButton(
                value: controller.isBaseUnit.value,
                onChanged: (value) => controller.isBaseUnit.value = value ?? false,
                trailingIcon: Tooltip(
                  message:
                      'Select or define the primary unit of measurement to which all other units in this category will be standardized or converted.',
                  child: Icon(Iconsax.info_circle),
                ),
                child: const Text('Base Unit'),
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
                        child: ElevatedButton(onPressed: () => controller.createUnit(), child: const Text('Create')),
                      ),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }

  // Custom dropdown builder using TDropdown
  Widget _customDropdown(CreateUnitController controller) {
    return TDropdown<UnitType>(
      labelText: 'Select Type',
      hintText: 'Select a unit type',
      selectedItem: controller.selectedUnitType.value,
      items: (query, _) async {
        // Return filtered unit type suggestions based on the search query
        return UnitType.values
            .where((unit) => unit.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      },
      itemAsString: (unit) => unit.name[0].toUpperCase() + unit.name.substring(1),
      onChanged: (suggestion) {
        if (suggestion != null) {
          controller.selectedUnitType.value = suggestion;
          controller.unitTypeTextField.text =
              suggestion.name[0].toUpperCase() + suggestion.name.substring(1);
        }
      },
      showSearchBox: true, // Enable search functionality
      noResultsText: "No unit types found", // Custom no results text
      loadingIndicator: const CircularProgressIndicator(), // Custom loading indicator
      compareFn: (item1, item2) => item1 == item2, // Add compareFn
    );
  }

  // // Custom dropdown builder to display formatted text
  // Widget _customDropdown(CreateUnitController controller) {
  //   return TSearchableDropdown(
  //     controller: controller.unitTypeTextField,
  //     labelText: 'Select Type',
  //     suggestionsCallback: (pattern) {
  //       // Return filtered brand suggestions based on the search pattern
  //       return UnitType.values.where((unit) => unit.name.contains(pattern)).toList();
  //     },
  //     itemBuilder: (context, suggestion) {
  //       return ListTile(
  //         title: Text(suggestion.name[0].toUpperCase() + suggestion.name.substring(1)),
  //       );
  //     },
  //     onSelected: (suggestion) {
  //       controller.selectedUnitType.value = suggestion;
  //       controller.unitTypeTextField.text = (suggestion.name[0].toUpperCase() + suggestion.name.substring(1));
  //     },
  //   );
  // }
}
