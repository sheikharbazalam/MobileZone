import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/review/review_controller.dart';
import '../../../../models/product_review_model.dart';

class ReviewTable extends StatelessWidget {
  const ReviewTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());
    return Column(
      children: [
        /// Table Header
        TTableHeader(
          buttonText: TTexts.createNewReviewButton.tr,
          searchController: controller.searchTextController,
          onCreatePressed: () => Get.toNamed(TRoutes.createReview),
          onSearchChanged: (value) => controller.searchQuery(value),
        ),
        SizedBox(height: TSizes().spaceBtwSections),

        /// Table
        Obx(
          () {
            return TDataTable(
              minWidth: 700,
              isLoading: controller.isLoading.value,
              sortAscending: controller.sortAscending.value,
              allItemsFetched: controller.allItemsFetched.value,
              sortColumnIndex: controller.sortColumnIndex.value,
              loadMoreButtonOnPressed: () => controller.fetchData(),
              columns: [
                DataColumn2(label: Text(TTexts.product.tr), size: ColumnSize.M),
                DataColumn2(label: Text(TTexts.review.tr), onSort: (index, asc) => controller.sortByName(index, asc), size: ColumnSize.L),
                DataColumn2(label: Text(TTexts.rating.tr), size: ColumnSize.S),
                DataColumn2(label: Text(TTexts.user.tr), size: ColumnSize.M),
                DataColumn2(label: Text(TTexts.status.tr), size: ColumnSize.S),
                DataColumn2(label: Text(TTexts.date.tr), size: ColumnSize.S),
                DataColumn2(label: Text(TTexts.action.tr), fixedWidth: 60),
              ],
              rows: controller.filteredItems.asMap().entries.map((entry) {
                final index = entry.key;
                final review = entry.value;
                return buildDataRow(controller, index, review, context);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  DataRow buildDataRow(ReviewController controller, int index, ReviewModel item, BuildContext context) {
    return DataRow(
      selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        // Product
        DataCell(
          InkWell(
            onTap: () => Get.toNamed(TRoutes.editProduct, parameters: {'id': item.productId}),
            child: Row(
              children: [
                TImage(
                  fit: BoxFit.contain,
                  backgroundColor: Colors.transparent,
                  imageType: item.productImage.isNotEmpty ? ImageType.network : ImageType.asset,
                  image: item.productImage.isNotEmpty ? item.productImage : TImages.user,
                ),
                SizedBox(width: TSizes().spaceBtwItems),
                Expanded(child: Text(item.productName.capitalize.toString(), style: Theme.of(context).textTheme.bodyLarge)),
              ],
            ),
          ),
        ),

        //Review
        DataCell(Text(item.reviewText.capitalize.toString(), style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors().primary))),

        // Rating
        DataCell(
          RatingBar.builder(
            initialRating: item.rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 20,
            ignoreGestures: true,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(CupertinoIcons.star_fill, color: Colors.amber),
            onRatingUpdate: (rating) {},
          ),
        ),

        // User
        DataCell(
          Row(
            children: [
              TImage(
                fit: BoxFit.contain,
                backgroundColor: Colors.transparent,
                imageType: item.userProfileImage != null && item.userProfileImage!.isNotEmpty ? ImageType.network : ImageType.asset,
                image: item.userProfileImage != null && item.userProfileImage!.isNotEmpty ? item.userProfileImage : TImages.user,
              ),
              SizedBox(width: TSizes().spaceBtwItems),
              Expanded(
                child: Text(
                  item.userName.capitalize.toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),

        // Active Switch
        DataCell(
          TAnimatedToggleSwitch(
            current: item.isApproved,
            loading: controller.statusToggleSwitchLoaders[index],
            textBuilder: (value) => value ? const Text('Approved') : const Text('Rejected'),
            onChanged: (value) async => controller.statusToggleSwitch(index: index, toggle: value, item: item),
          ),
        ),
        DataCell(Text(item.formattedDate)),
        DataCell(
          TTableActionButtons(
            edit: false,
            onDeletePressed: () => controller.confirmAndDeleteItem(item),
          ),
        ),
      ],
    );
  }
}
