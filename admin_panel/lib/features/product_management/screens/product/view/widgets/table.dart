import 'package:cwt_ecommerce_admin_panel/features/role_management/controllers/role/role_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/product/product_controller.dart';
import '../../../../models/product_model.dart';

class ProductTable extends StatelessWidget {
  const ProductTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    final roleController = RoleController.instance;

    return Column(
      children: [
        /// Table Header
        TTableHeader(
          buttonText: TTexts.createNewProduct.tr,
          searchController: controller.searchTextController,
          onCreatePressed: () => Get.toNamed(TRoutes.createProduct),
          onSearchChanged: (value) => controller.searchQuery(value),
          showCreateButton: roleController.checkUserPermission(Permission.createProducts),
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
                DataColumn2(
                    label: Text(TTexts.product.tr),
                    onSort: (index, asc) => controller.sortByName(index, asc),
                    size: ColumnSize.L),
                 DataColumn2(label: Text(TTexts.price.tr), size: ColumnSize.S),
                 DataColumn2(label: Text(TTexts.brand.tr), size: ColumnSize.S),
                 DataColumn2(label: Text(TTexts.productType.tr), size: ColumnSize.S),
                 DataColumn2(label: Text(TTexts.stock.tr), size: ColumnSize.S),
                 DataColumn2(label: Text(TTexts.productVisibility.tr), size: ColumnSize.S),
                 DataColumn2(label: Text(TTexts.featured.tr), size: ColumnSize.S),
                 DataColumn2(label: Text(TTexts.status.tr), size: ColumnSize.S),
                 DataColumn2(label: Text(TTexts.date.tr), size: ColumnSize.S),
                 DataColumn2(label: Text(TTexts.action.tr), size: ColumnSize.S),
              ],
              rows: controller.filteredItems.asMap().entries.map((entry) {
                final index = entry.key;
                final attribute = entry.value;
                return buildDataRow(controller,roleController, index, attribute, context);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  DataRow buildDataRow(ProductController controller,RoleController roleController, int index, ProductModel item, BuildContext context) {
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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),

        // Price and Sale Tag
        DataCell(
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: TSizes().sm, // spacing between children
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 150), // limit width in tablets
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.getProductPriceWithoutSalePrice.isNotEmpty &&
                        item.getProductPriceWithoutSalePrice != item.getProductPrice)
                      Text(
                        item.getProductPriceWithoutSalePrice,
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                      ),
                    Text(
                      item.getProductPrice,
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (item.getMaxDiscountPercentage != null && item.getMaxDiscountPercentage!.isNotEmpty)
                TContainer(
                  borderRadius: BorderRadius.circular(100),
                  backgroundColor: Colors.green.withValues(alpha: 0.2),
                  padding: EdgeInsets.symmetric(
                    horizontal: TSizes().sm,
                    vertical: TSizes().sm / 4,
                  ),
                  child: Text(
                    '-${item.getMaxDiscountPercentage!}%',
                    style: Theme.of(context).textTheme.labelLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),

        // Brand
        DataCell(
          item.brand != null
              ? InkWell(
                  onTap:
                      item.brand != null ? () => Get.toNamed(TRoutes.editBrand, parameters: {'id': item.brand!.id}) : () {},
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    item.brand!.name.capitalize.toString(),
                    style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors().primary),
                  ),
                )
              : TContainer(
                  borderRadius: BorderRadius.circular(100),
                  backgroundColor: TColors().warning.withValues(alpha: 0.2),
                  padding: EdgeInsets.symmetric(horizontal: TSizes().sm, vertical: TSizes().sm / 2),
                  child: Text('N/A', style: Theme.of(context).textTheme.labelLarge),
                ),
        ),

        // Type
        DataCell(
          TContainer(
            padding: EdgeInsets.symmetric(vertical: TSizes().sm, horizontal: TSizes().md),
            backgroundColor: item.productType == ProductType.simple
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.deepPurple.withValues(alpha: 0.1),
            child: Text(
              item.productType.name.capitalize.toString(),
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .apply(color: item.productType == ProductType.simple ? Colors.green : Colors.deepPurple),
            ),
          ),
        ),

        // Stock
        DataCell(Text(item.getStockTotal.toString(), style: Theme.of(context).textTheme.bodyLarge)),
        DataCell(
          TContainer(
            padding: EdgeInsets.symmetric(vertical: TSizes().sm, horizontal: TSizes().md),
            backgroundColor: item.isDraft ? Colors.grey.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
            child: Text(
              item.isDraft ? 'Draft' : 'Published',
              style: Theme.of(context).textTheme.labelLarge!.apply(color: item.isDraft ? Colors.grey : Colors.blue),
            ),
          ),
        ),

        // Featured
        DataCell(
          TIconToggleSwitch<bool>(
            current: item.isFeatured,
            options: const [true, false],
            loading: controller.featuredToggleSwitchLoaders[index],
            icons: const [Icons.check_circle, Iconsax.close_circle],
            onChanged: (value) => controller.featuredToggleSwitch(index: index, toggle: value, item: item),
          ),

          // TAnimatedToggleSwitch(
          //   current: item.isFeatured,
          //   loading: controller.featuredToggleSwitchLoaders[index],
          //   textBuilder: (active) => active ? const Text('Featured') : const Text('No'),
          //   onChanged: (value) async => controller.featuredToggleSwitch(index: index, toggle: value, item: item),
          // ),
        ),

        // Status
        DataCell(
          TIconToggleSwitch<bool>(
            current: item.isActive,
            options: const [true, false],
            loading: controller.statusToggleSwitchLoaders[index],
            icons: const [Icons.check_circle, Iconsax.close_circle],
            onChanged: (value) => controller.statusToggleSwitch(index: index, toggle: value, item: item),
          ),
          // TAnimatedToggleSwitch(
          //   current: item.isActive,
          //   loading: controller.statusToggleSwitchLoaders[index],
          //   textBuilder: (active) => active ? const Text('Live') : const Text('Paused'),
          //   onChanged: (value) async => controller.statusToggleSwitch(index: index, toggle: value, item: item),
          // ),
        ),

        DataCell(Text(item.formattedDate, style: Theme.of(context).textTheme.bodyLarge)),
        DataCell(
          TTableActionButtons(
            onDeletePressed: () => controller.confirmAndDeleteItem(item),
            onEditPressed: () => Get.toNamed(TRoutes.editProduct, arguments: item, parameters: {'id': item.id}),
            delete: roleController.checkUserPermission(Permission.deleteProducts),
            edit: roleController.checkUserPermission(Permission.updateProducts),
          ),
        ),
      ],
    );
  }
}
