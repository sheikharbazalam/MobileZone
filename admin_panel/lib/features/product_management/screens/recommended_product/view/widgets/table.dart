import 'package:cwt_ecommerce_admin_panel/features/role_management/controllers/role/role_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../controllers/recommended_products/recommended_product_controller.dart';
import '../../../../models/product_model.dart';

class ProductTable extends StatelessWidget {
  const ProductTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecommendedProductController());
    final roleController = RoleController.instance;

    return Column(
      children: [
        /// Table Header
        TTableHeader(
          buttonText: 'View All Products',
          searchController: controller.searchTextController,
          onCreatePressed: () => Get.toNamed(TRoutes.products),
          onSearchChanged: (value) => controller.searchQuery(value),
        ),
        SizedBox(height: TSizes().spaceBtwSections),

        /// Table
        Obx(
          () {
            return TDataTable(
              minWidth: 1200,
              isLoading: controller.isLoading.value,
              sortAscending: controller.sortAscending.value,
              allItemsFetched: controller.allItemsFetched.value,
              sortColumnIndex: controller.sortColumnIndex.value,
              loadMoreButtonOnPressed: () => controller.fetchData(),
              columns: [
                DataColumn2(label: const Text('Product'), onSort: (index, asc) => controller.sortByName(index, asc), size: ColumnSize.L),
                const DataColumn2(label: Text('Price'), size: ColumnSize.S),
                const DataColumn2(label: Text('Recommended'), size: ColumnSize.S),
                const DataColumn2(label: Text('Type'), size: ColumnSize.S),
                const DataColumn2(label: Text('Stock'), size: ColumnSize.S),
                const DataColumn2(label: Text('Date'), size: ColumnSize.S),
                const DataColumn2(label: Text('Action'), size: ColumnSize.S),
              ],
              rows: controller.filteredItems.asMap().entries.map((entry) {
                final index = entry.key;
                final attribute = entry.value;
                return buildDataRow(controller, roleController,index, attribute, context);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  DataRow buildDataRow(RecommendedProductController controller,RoleController roleController, int index, ProductModel item, BuildContext context) {
    return DataRow(
      selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        // Title Description and Image
        DataCell(
          Row(
            children: [
              TImage(
                image: item.thumbnail.isNotEmpty ? item.thumbnail : TImages.defaultImage,
                imageType: item.thumbnail.isNotEmpty ? ImageType.network : ImageType.asset,
              ),
              SizedBox(width: TSizes().spaceBtwItems),
              Expanded(
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  item.title.capitalize.toString(),
                  style: Theme.of(context).textTheme.titleLarge!.apply(color: TColors().primary),
                ),
              ),
            ],
          ),
        ),

        // Price and Sale Tag
        DataCell(
          Row(
            spacing: TSizes().sm,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.getProductPriceWithoutSalePrice.isNotEmpty && item.getProductPriceWithoutSalePrice != item.getProductPrice)
                    Text(
                      item.getProductPriceWithoutSalePrice,
                      style: Theme.of(context).textTheme.labelLarge!.apply(decoration: TextDecoration.lineThrough, color: Colors.grey),
                    ),
                  Text(item.getProductPrice, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
              if (item.getMaxDiscountPercentage != null && item.getMaxDiscountPercentage!.isNotEmpty)
                TContainer(
                  borderRadius: BorderRadius.circular(100),
                  backgroundColor: Colors.green.withValues(alpha: 0.2),
                  padding: EdgeInsets.symmetric(horizontal: TSizes().sm, vertical: TSizes().sm / 2),
                  child: Text('-${item.getMaxDiscountPercentage!}%', style: Theme.of(context).textTheme.labelLarge),
                ),
            ],
          ),
        ),

        // Recommended
        DataCell(
          Obx(
            () => TIconToggleSwitch<bool>(
              current: item.isRecommended,
              options: const [true, false],
              loading: controller.statusToggleSwitchLoaders[index],
              icons: const [Icons.check_circle, Iconsax.close_circle],
              onChanged: (value) => controller.statusToggleSwitch(index: index, toggle: value, item: item),
            ),
            // TAnimatedToggleSwitch(
            //   current: item.isRecommended,
            //   loading: controller.statusToggleSwitchLoaders[index],
            //   textBuilder: (active) => active ? const Icon(Iconsax.heart5, color: TColors().primary) : const Icon(Iconsax.heart),
            //   onChanged: (value) => controller.statusToggleSwitch(index: index, toggle: value, item: item),
            // ),
          ),
        ),

        // Type
        DataCell(
          TContainer(
            padding: EdgeInsets.symmetric(vertical: TSizes().sm, horizontal: TSizes().md),
            backgroundColor:
                item.productType == ProductType.simple ? Colors.green.withValues(alpha: 0.1) : Colors.deepPurple.withValues(alpha: 0.1),
            child: Text(
              item.productType.name.capitalize.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .apply(color: item.productType == ProductType.simple ? Colors.green : Colors.deepPurple),
            ),
          ),
        ),

        // Stock
        DataCell(Text(controller.stockTotal(item.productType, item.stock, item.variations ?? []).toString(),
            style: Theme.of(context).textTheme.bodyLarge)),

        DataCell(Text(item.formattedDate, style: Theme.of(context).textTheme.bodyLarge)),
        DataCell(
          TTableActionButtons(
            onDeletePressed: () => controller.confirmAndDeleteItem(item),
            onEditPressed: () => Get.toNamed(TRoutes.editProduct, arguments: item, parameters: {'id': item.id}),
            delete:  roleController.checkUserPermission(Permission.deleteProducts),
            edit:  roleController.checkUserPermission(Permission.updateProducts),
          ),
        ),
      ],
    );
  }
}
