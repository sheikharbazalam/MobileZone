import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/media_controller.dart';
import '../../../models/image_model.dart';
import 'folder_dropdown.dart';

class MediaUploader extends StatelessWidget {
  const MediaUploader({
    super.key,
    this.isSideBar = false,
  });

  final bool isSideBar;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MediaController());
    return TContainer(
      showShadow: true,
      borderRadius: isSideBar ? const BorderRadius.all(Radius.zero) : null,
      width: TDeviceUtils.isMobileScreen(context) ? TDeviceUtils.getScreenWidth(context) : 500,
      height: TDeviceUtils.getScreenHeight(context) * 0.8,
      backgroundColor: TColors().white,
      padding: EdgeInsets.all(TSizes().defaultSpace),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            if (isSideBar)
              Column(
                children: [
                  SizedBox(height: TSizes().appBarHeight),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => controller.showImagesUploaderSection.value = false, icon: const Icon(Iconsax.close_circle)),
                      SizedBox(width: TSizes().spaceBtwItems),
                      Text(TTexts.uploadImages.tr, style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ],
              ),
            SizedBox(height: TSizes().spaceBtwSections),

            // Drop Zone
            TContainer(
              height: 250,
              showBorder: true,
              borderColor: TColors().borderPrimary,
              backgroundColor: TColors().white,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        DropzoneView(
                          mime: const ['image/jpeg', 'image/png'],
                          cursor: CursorType.Default,
                          operation: DragOperation.copy,
                          onCreated: (ctrl) => controller.dropzoneController = ctrl,
                          onLoaded: () => print('Zone loaded'),
                          onError: (ev) => print('Zone error: $ev'),
                          onHover: () {
                            print('Zone hovered');
                          },
                          onLeave: () {
                            print('Zone left');
                          },
                          onDropFile: (DropzoneFileInterface ev) async {
                            // Retrieve file data as Uint8List
                            final bytes = await controller.dropzoneController.getFileData(ev);

                            // Extract file metadata
                            final filename = await controller.dropzoneController.getFilename(ev);
                            final mimeType = await controller.dropzoneController.getFileMIME(ev);

                            final image = ImageModel(
                              url: '',
                              folder: '',
                              uploadedBy: '',
                              filename: filename,
                              contentType: mimeType,
                              localImageToDisplay: Uint8List.fromList(bytes),
                            );
                            controller.selectedImagesToUpload.add(image);
                          },
                          onDropInvalid: (ev) => print('Zone invalid MIME: $ev'),
                          onDropFiles: (ev) async {
                            print('Zone drop multiple: $ev');
                          },
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(TImages.defaultMultiImageIcon, width: 50, height: 50),
                            SizedBox(height: TSizes().spaceBtwItems),
                            Text(TTexts.dragAndDropImagesHere.tr),
                            SizedBox(height: TSizes().spaceBtwItems),
                            OutlinedButton(onPressed: () => controller.selectLocalImages(), child: const Text('Select Images')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: TSizes().spaceBtwSections * 2),

            // Show locally selected images
            Obx(() => (controller.selectedImagesToUpload.isNotEmpty)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Storage Type Dropdown
                      Text(TTexts.selectStorageType.tr, style: Theme.of(context).textTheme.headlineSmall),
                      Text(TTexts.chooseStorage.tr, style: Theme.of(context).textTheme.bodySmall),
                      SizedBox(height: TSizes().spaceBtwItems),
                      DropdownButtonFormField<StorageType>(
                        isExpanded: false,
                        onChanged: (StorageType? newValue) {
                          if (newValue != null) {
                            controller.selectedStorageType.value = newValue;
                            controller.getMediaImages();
                          }
                        },
                        value: controller.selectedStorageType.value,
                        items: StorageType.values.map(
                          (category) {
                            return DropdownMenuItem<StorageType>(
                              value: category,
                              child: Text(category.name.capitalize.toString()),
                            );
                          },
                        ).toList(),
                      ),
                      SizedBox(height: TSizes().spaceBtwSections),

                      Text(TTexts.selectFolder.tr, style: Theme.of(context).textTheme.headlineSmall),
                      Text(TTexts.chooseFolder.tr, style: Theme.of(context).textTheme.bodySmall),
                      SizedBox(height: TSizes().spaceBtwItems),
                      MediaFolderDropdown(
                        width: double.infinity,
                        onChanged: (MediaCategory? newValue) {
                          if (newValue != null) {
                            controller.selectedPath.value = newValue;
                            controller.getMediaImages();
                          }
                        },
                      ),
                      SizedBox(height: TSizes().spaceBtwSections),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: TSizes().spaceBtwItems / 2,
                        runSpacing: TSizes().spaceBtwItems / 2,
                        children: controller.selectedImagesToUpload
                            .where((image) => image.localImageToDisplay != null)
                            .map((element) => TImageUploader(
                                  width: 90,
                                  height: 90,
                                  top: TSizes().sm / 2,
                                  right: TSizes().sm / 2,
                                  left: null,
                                  bottom: null,
                                  icon: Iconsax.trash,
                                  imageType: ImageType.memory,
                                  memoryImage: element.localImageToDisplay,
                                  onIconButtonPressed: () => controller.selectedImagesToUpload.remove(element),
                                ))
                            .toList(),
                      ),
                      SizedBox(height: TSizes().spaceBtwSections),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () => controller.uploadImagesConfirmation(), child: Text(TTexts.uploadImages.tr)),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.box_search, color: TColors().primary, size: 80),
                          SizedBox(height: TSizes().spaceBtwItems),
                          Text(TTexts.itsEmptyHere.tr, style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ],
                  )),
            SizedBox(height: isSideBar ? null : TSizes().spaceBtwSections),
          ],
        ),
      ),
    );
  }
}
