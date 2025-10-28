import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/media_controller.dart';
import '../../../models/image_model.dart';
import 'view_image_details.dart';

class MediaContent extends StatelessWidget {
  MediaContent({
    super.key,
    this.allowSelection = false,
    this.allowMultipleSelection = false,
    this.onImagesSelected,
    this.alreadySelectedUrls,
  });

  final bool allowSelection;
  final bool allowMultipleSelection;
  final List<String>? alreadySelectedUrls;
  final List<ImageModel> selectedImages = [];
  final Function(List<ImageModel> selectedImages)? onImagesSelected;

  @override
  Widget build(BuildContext context) {
    bool loadedPreviousSelection = false;
    final controller = Get.put(MediaController());
    return TContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Media Images Header
          _mediaContentHeader(context, controller),
          SizedBox(height: TSizes().spaceBtwSections),

          // Show Media
          Obx(
                () {
              if (controller.selectedPath.value == MediaCategory.none) return _buildEmptyAnimationWidget(context, controller);

              // Get Selected Folder Images
              List<ImageModel> images = _getSelectedFolderImages(controller);

              // Load Selected Images from the Already Selected Images only once otherwise
              // on Obx() rebuild UI first images will be selected then will auto un check.
              if (!loadedPreviousSelection) {
                if (alreadySelectedUrls != null && alreadySelectedUrls!.isNotEmpty) {
                  // Convert alreadySelectedUrls to a Set for faster lookup
                  final selectedUrlsSet = Set<String>.from(alreadySelectedUrls!);

                  for (var image in images) {
                    image.isSelected.value = selectedUrlsSet.contains(image.url);
                    if (image.isSelected.value) {
                      selectedImages.add(image);
                    }
                  }
                } else {
                  // If alreadySelectedUrls is null or empty, set all images to not selected
                  for (var image in images) {
                    image.isSelected.value = false;
                  }
                }
                loadedPreviousSelection = true;
              }

              // Loader
              if (controller.loading.value && images.isEmpty) return loaderToFetchImages();

              // Empty Widget
              if (images.isEmpty) return _buildEmptyAnimationWidget(context, controller);

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: images
                        .map((image) =>
                        GestureDetector(
                          onTap: () => Get.dialog(ImagePopup(image: image)),
                          child: SizedBox(
                            width: 160,
                            height: 180,
                            child: Column(
                              children: [
                                allowSelection ? _buildListWithCheckbox(image) : _buildSimpleList(image),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: TSizes().sm),
                                    child: Text(image.filename, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                        .toList(),
                  ),
                  SizedBox(height: TSizes().spaceBtwSections),
                  Divider(color: TColors().lightBackground),

                  /// Load More Section
                  if (controller.allImagesFetched[controller.selectedPath.value]!.value)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${TTexts.youAreViewingAllImages.tr} ${controller.selectedPath.value.name.capitalize}',),
                      ],
                    )
                  else
                  // Load More Button -> Show when all images loaded
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.loading.value ? () {} : () => controller.loadMoreMediaImages(),
                          label: controller.loading.value ? Text(TTexts.loading.tr) : Text(TTexts.loadMore.tr),
                          icon: const Icon(Iconsax.arrow_down),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _mediaContentHeader(BuildContext context, MediaController controller) {
    return TDeviceUtils.isMobileScreen(context)
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add Selected Images Button
        if (allowSelection) buildAddSelectedImagesButton(context, controller),
        SizedBox(height: TSizes().spaceBtwSections),

        // Media Dropdown
        _buildMediaDropdown(context, controller),
      ],
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMediaDropdown(context, controller),

        // Add Selected Images Button
        if (allowSelection) buildAddSelectedImagesButton(context, controller),
      ],
    );
  }

  Padding loaderToFetchImages() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TSizes().defaultSpace * 2),
      child: Column(
        children: [
          TAnimationLoader(height: 300, width: 300),
        ],
      ),
    );
  }

  Padding _buildEmptyAnimationWidget(BuildContext context, MediaController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TSizes().lg * 3),
      child: TAnimationLoader(
        width: 300,
        height: 300,
        message: Text((controller.selectedPath.value == MediaCategory.none)
            ? TTexts.chooseFolderToUpload.tr
            : TTexts.noImagesFound.tr),
        animation: TImages.mediaIllustration,
        style: Theme
            .of(context)
            .textTheme
            .titleLarge,
      ),
    );
  }

  List<ImageModel> _getSelectedFolderImages(MediaController controller) {
    return controller.mediaFolders[controller.selectedPath.value]!.where((image) => image.url.isNotEmpty).toList();
  }

  Widget buildAddSelectedImagesButton(BuildContext context, MediaController controller) {
    return TDeviceUtils.isMobileScreen(context)
        ? Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Upload Button
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                label: Text(TTexts.uploadImages.tr),
                icon: const Icon(Iconsax.document_upload),
                onPressed: () => controller.uploadImagesPopup(context),
              ),
            ),
            SizedBox(width: TSizes().spaceBtwItems),
            Expanded(
              child: ElevatedButton.icon(
                label: Text(TTexts.add.tr),
                icon: const Icon(Iconsax.image, color: Colors.white),
                onPressed: () => Get.back(result: selectedImages),
              ),
            ),
          ],
        ),
      ],
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Upload Button
        SizedBox(
          width: 200,
          child: OutlinedButton.icon(
            label: Text(TTexts.uploadImages.tr),
            icon: const Icon(Iconsax.gallery),
            onPressed: () => controller.uploadImagesPopup(context),
          ),
        ),
        SizedBox(width: TSizes().spaceBtwItems),
        SizedBox(
          width: 120,
          child: ElevatedButton.icon(
            label: Text(TTexts.add.tr),
            icon: const Icon(Iconsax.image, color: Colors.white),
            onPressed: () => Get.back(result: selectedImages),
          ),
        ),
      ],
    );
  }

  Obx _buildMediaDropdown(BuildContext context, MediaController controller) {
    return Obx(
          () =>
          SizedBox(
            width: TDeviceUtils.isMobileScreen(context) ? double.infinity : 300,
            child: DropdownButtonFormField<MediaCategory>(
              isExpanded: false,
              value: controller.selectedPath.value,
              decoration: InputDecoration(prefixIcon: Icon(Iconsax.folder_open5, color: TColors().primary)),
              onChanged: (MediaCategory? newValue) {
                if (newValue != null) {
                  for (var image in selectedImages) {
                    image.isSelected.value = false;
                  }
                  selectedImages.clear();

                  controller.selectedPath.value = newValue;
                  controller.getMediaImages();
                }
              },
              items: MediaCategory.values.map(
                    (category) {
                  return DropdownMenuItem<MediaCategory>(
                    value: category,
                    child: Text(category.name.capitalize.toString()),
                  );
                },
              ).toList(),
            ),
          ),
    );
  }

  Widget _buildSimpleList(ImageModel image) {
    return TImage(
      width: 140,
      height: 140,
      padding: TSizes().sm,
      image: image.url,
      imageType: ImageType.network,
      margin: TSizes().spaceBtwItems / 2,
      backgroundColor: TColors().lightBackground,
    );
  }

  Widget _buildListWithCheckbox(ImageModel image) {
    return Stack(
      children: [
        TImage(
          width: 140,
          height: 140,
          padding: TSizes().sm,
          image: image.url,
          imageType: ImageType.network,
          margin: TSizes().spaceBtwItems / 2,
          backgroundColor: TColors().lightBackground,
        ),
        Positioned(
          top: TSizes().md,
          right: TSizes().md,
          child: Obx(
                () =>
                Checkbox(
                  value: image.isSelected.value,
                  onChanged: (selected) {
                    // If selection is allowed, toggle the selected state
                    if (selected != null) {
                      image.isSelected.value = selected;
                      if (image.isSelected.value) {
                        if (!allowMultipleSelection) {
                          // If multiple selection is not allowed, uncheck other checkboxes
                          for (var otherImage in selectedImages) {
                            if (otherImage != image) {
                              otherImage.isSelected.value = false;
                            }
                          }
                          selectedImages.clear();
                        }

                        selectedImages.add(image);
                      } else {
                        selectedImages.remove(image);
                      }
                    }
                  },
                ),
          ),
        ),
      ],
    );
  }
}
