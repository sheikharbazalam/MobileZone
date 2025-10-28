import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../data_management/controllers/brand/brand_controller.dart';
import '../../../../../data_management/models/brand_model.dart';
import '../../../../controllers/product/create_product_controller.dart';

class ProductBrand extends StatelessWidget {
  const ProductBrand({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get instances of controllers
    final controller = Get.put(CreateProductController());
    final brandController = Get.put(BrandController());

    // Fetch brands if the list is empty
    if (brandController.allItems.isEmpty) {
      brandController.fetchItems();
    }

    return TContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand label
          TTextWithIcon(text: TTexts.productBrand.tr, icon: Iconsax.dcube),
          SizedBox(height: TSizes().spaceBtwItems),

          // TypeAheadField for brand selection
          Obx(
            () => brandController.isLoading.value
                ? const TShimmer(width: double.infinity, height: 50)
                : TDropdown<BrandModel>(
                    labelText: TTexts.selectBrand.tr,
                    hintText: TTexts.selectDesiredBrand.tr,
                    selectedItem: controller.selectedBrand.value,
                    items: (query, _) async {
                      return brandController.allItems.where((brand) => brand.name.contains(query)).toList();
                      // return [
                      //   BrandModel(id: '', name: 'Unselect', imageURL: ''), // Add an unselect option
                      //   ...brands,
                      // ];
                    },
                    itemAsString: (suggestion) => suggestion.name,
                    onChanged: (suggestion) {
                      if (suggestion == null || suggestion.id.isEmpty) {
                        // Handle "Unselect" option
                        controller.selectedBrand.value = null;
                        controller.brandTextField.clear();
                      } else {
                        controller.selectedBrand.value = suggestion;
                        controller.brandTextField.text = suggestion.name[0].toUpperCase() + suggestion.name.substring(1);
                      }
                    },
                    showSearchBox: true,
                    // Enable search functionality
                    noResultsText: TTexts.noBrandsFound.tr,
                    // Custom no results text
                    loadingIndicator: const CircularProgressIndicator(),
                    // Custom loading indicator
                    compareFn: (item1, item2) => item1 == item2, // Add compareFn
                  ),
          ),
        ],
      ),
    );
  }
}
