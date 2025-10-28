import 'dart:typed_data';

import 'package:cwt_ecommerce_admin_panel/features/personalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';
import 'package:t_utils/t_utils.dart';

import '../../../data/repositories/media/media_repository.dart';
import '../../../data/repositories/media/supabase_storage.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/text_strings.dart';
import '../models/image_model.dart';
import '../screens/media/widgets/media_content.dart';
import '../screens/media/widgets/media_uploader.dart';

/// Controller for managing media operations
class MediaController extends GetxController {
  static MediaController get instance => Get.find();

  late DropzoneViewController dropzoneController;

  // Lists to store additional product images
  final int loadMoreCount = 25;
  final int initialLoadCount = 20;
  final RxBool loading = false.obs;
  final RxBool showImagesUploaderSection = false.obs;
  final Rx<StorageType> selectedStorageType = StorageType.firebase.obs;
  final Rx<MediaCategory> selectedPath = MediaCategory.none.obs;

  final Map<MediaCategory, RxBool> allImagesFetched = {
    MediaCategory.categories: false.obs,
    MediaCategory.brands: false.obs,
    MediaCategory.banners: false.obs,
    MediaCategory.products: false.obs,
    MediaCategory.personalized: false.obs,
  };

  final Map<MediaCategory, RxList<ImageModel>> mediaFolders = {
    MediaCategory.categories: <ImageModel>[].obs,
    MediaCategory.brands: <ImageModel>[].obs,
    MediaCategory.banners: <ImageModel>[].obs,
    MediaCategory.products: <ImageModel>[].obs,
    MediaCategory.personalized: <ImageModel>[].obs,
  };

  final RxList<ImageModel> selectedImagesToUpload = <ImageModel>[].obs;
  final MediaRepository mediaRepository = MediaRepository();

  // Get Images
  void getMediaImages() async {
    try {
      loading.value = true;

      // Check if selected Path Exist, Fetch Data
      if (mediaFolders[selectedPath.value] != null) {
        final images = await mediaRepository.fetchImagesFromDatabase(selectedPath.value, initialLoadCount);
        mediaFolders[selectedPath.value]!.assignAll(images);

        if (images.length < initialLoadCount) allImagesFetched[selectedPath.value]!.value = true;
      }
    } catch (e) {
      TNotificationOverlay.error(context: Get.context!, title: e.toString());
    } finally {
      loading.value = false;
    }
  }

  // Load More Images
  loadMoreMediaImages() async {
    try {
      if (selectedPath.value == MediaCategory.none) return;
      loading.value = true;

      DateTime lastFetchedDate = mediaFolders[selectedPath.value]!.last.createdAt ?? DateTime.now();
      final images = await mediaRepository.loadMoreImagesFromDatabase(selectedPath.value, loadMoreCount, lastFetchedDate);

      mediaFolders[selectedPath.value]!.addAll(images);

      if (images.length < loadMoreCount) allImagesFetched[selectedPath.value]!.value = true;

      loading.value = false;
    } catch (e) {
      loading.value = false;
      TNotificationOverlay.error(context: Get.context!, title: e.toString());
    }
  }

  /// Select Local Images on Button Press
  Future<void> selectLocalImages() async {
    try {
      final files = await dropzoneController.pickFiles(multiple: true, mime: ['image/jpeg', 'image/png']);

      if (files.isNotEmpty) {
        for (var file in files) {
          // Retrieve file data as Uint8List
          final bytes = await dropzoneController.getFileData(file);

          // Extract file metadata
          final filename = await dropzoneController.getFilename(file);
          final mimeType = await dropzoneController.getFileMIME(file);

          final image = ImageModel(
            url: '',
            folder: '',
            uploadedBy: '',
            filename: filename,
            contentType: mimeType,
            localImageToDisplay: Uint8List.fromList(bytes),
          );

          selectedImagesToUpload.add(image);
        }
      }
    } catch (e) {
      TNotificationOverlay.error(context: Get.context!, title: e.toString());
    }
  }

  /// Upload Images Confirmation Popup
  void uploadImagesConfirmation() {
    if (selectedPath.value == MediaCategory.none) {
      TNotificationOverlay.info(
          context: Get.context!, title: TTexts.selectFolder.tr, subTitle: TTexts.pleaseSelectFolder.tr);
      return;
    }

    if (mediaFolders[selectedPath.value] == null) {
      TNotificationOverlay.warning(
          context: Get.context!, title: TTexts.folderNotFound.tr, subTitle: TTexts.chooseFolder.tr);
      return;
    }

    /// Confirmation Popup
    TDialogs.defaultDialog(
      context: Get.context!,
      title: TTexts.uploadImages.tr,
      confirmText: TTexts.uploadImages.tr,
      onConfirm: () async => await uploadImages(),
      content: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '${TTexts.areYouSureUploadImages.tr} '),
            TextSpan(text: selectedStorageType.value.name.toUpperCase(), style: Theme.of(Get.context!).textTheme.titleLarge),
            TextSpan(text: ' database & the folder is '),
            TextSpan(text: selectedPath.value.name.toUpperCase(), style: Theme.of(Get.context!).textTheme.titleLarge),
            TextSpan(text: ' folder?'),
          ],
        ),
      ),
    );
  }

  /// Upload Images
  Future<void> uploadImages() async {
    try {
      // Remove confirmation box
      Get.back();

      // Start Loader
      uploadImagesLoader();

      if (UserController.instance.user.value.role != AppRole.superAdmin) {
        throw 'You are not authorized to make changes in the Media';
      }

      // Upload and add images to the target list
      // Using a reverse loop to avoid 'Concurrent modification during iteration' error
      for (int i = selectedImagesToUpload.length - 1; i >= 0; i--) {
        var selectedImage = selectedImagesToUpload[i];

        ImageModel uploadedImage = ImageModel.empty();

        // Upload Image to the Storage
        if (selectedStorageType.value == StorageType.firebase) {
          uploadedImage = await mediaRepository.uploadImageFileInStorage(
            fileData: selectedImage.localImageToDisplay!,
            mimeType: selectedImage.contentType!,
            path: getSelectedPath(),
            imageName: selectedImage.filename,
          );
        } else if (selectedStorageType.value == StorageType.supabase) {
          // Upload Image in Supabase Storage and Get URL
          uploadedImage = await SupabaseStorageService.instance.uploadImage(
            fileData: selectedImage.localImageToDisplay!,
            path: getSelectedPath(),
            mimeType: selectedImage.contentType!,
            fileName: selectedImage.filename,
          );
        }

        if (uploadedImage.url.isEmpty) return;

        // Upload Image to the Firestore
        uploadedImage.mediaCategory = selectedPath.value.name;
        uploadedImage.storageType = selectedStorageType.value;
        final id = await mediaRepository.uploadImageFileInDatabase(uploadedImage);

        uploadedImage.id = id;

        selectedImagesToUpload.removeAt(i);
        mediaFolders[selectedPath.value]!.insert(0, uploadedImage);
      }

      // Close the Images Uploader Section
      showImagesUploaderSection.value = false;

      // Stop Loader after successful upload
      TFullScreenLoader.stopLoading();
    } catch (e) {
      // Stop Loader in case of an error
      TFullScreenLoader.stopLoading();
      // Show the error
      TNotificationOverlay.error(context: Get.context!, title: 'Error Uploading Images', subTitle: e.toString());
    }
  }

  /// Upload Images Loader
  void uploadImagesLoader() {
    TDialogs.defaultDialog(
      canPop: false,
      hideActions: true,
      context: Get.context!,
      title: 'Uploading Images',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(TImages.uploadingImageIllustration, height: 300, width: 300),
          SizedBox(height: TSizes().spaceBtwItems),
          const Text(TTexts.uploadingImagesSitTight),
        ],
      ),
    );
  }

  /// Get Selected Folder Path for Firebase Storage
  String getSelectedPath() {
    String path = '';
    switch (selectedPath.value) {
      case MediaCategory.categories:
        path = TTexts.categoriesStoragePath;
        break;
      case MediaCategory.brands:
        path = TTexts.brandsStoragePath;
        break;
      case MediaCategory.banners:
        path = TTexts.bannersStoragePath;
        break;
      case MediaCategory.products:
        path = TTexts.productsStoragePath;
        break;
      case MediaCategory.personalized:
        path = TTexts.usersStoragePath;
        break;
      default:
        path = 'Others';
    }

    return path;
  }

  /// Popup Confirmation to remove cloud image
  void removeCloudImageConfirmation(ImageModel image) {
    // Delete Confirmation
    TDialogs.defaultDialog(
      context: Get.context!,
      content: Text(TTexts.deleteImageConfirm.tr),
      onConfirm: () {
        // Close the previous Dialog Image Popup
        Get.back();

        removeCloudImage(image);
      },
    );
  }

  /// Function to remove cloud image
  removeCloudImage(ImageModel image) async {
    try {
      // Close the removeCloudImageConfirmation() DDialog
      Get.back();

      // Show Loader
      Get.defaultDialog(
        title: '',
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const PopScope(canPop: false, child: SizedBox(width: 150, height: 150, child: TCircularLoader())),
      );

      if (UserController.instance.user.value.role != AppRole.superAdmin) {
        throw 'You are not authorized to make changes in the Media';
      }

      // Delete Image from Firebase Storage or Supabase Storage
      if (image.storageType == null || image.storageType == StorageType.firebase) {
        // Delete Image from Firebase Storage
        await mediaRepository.deleteFileFromStorage(image);
      } else if (image.storageType != null && image.storageType == StorageType.supabase) {
        // Delete Image from Supabase Storage
        await SupabaseStorageService.instance.deleteImage(image);
      }

      // Remove from the list
      mediaFolders[selectedPath.value]!.remove(image);

      update();
      TFullScreenLoader.stopLoading();

      TNotificationOverlay.success(
        context: Get.context!,
        title: TTexts.imageDeleted.tr,
        subTitle: TTexts.imageDeletedSuccess.tr,
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TNotificationOverlay.error(context: Get.context!, title:TTexts.ohSnap.tr, subTitle: e.toString());
    }
  }

  /// Images Selection Bottom Sheet
  Future<List<ImageModel>?> selectImagesFromMedia({
    List<String>? alreadySelectedUrls,
    bool allowSelection = true,
    bool allowMultipleSelection = false,
  }) async {
    try {
      List<ImageModel>? selectedImages = await Get.bottomSheet<List<ImageModel>>(
        backgroundColor: TColors().lightBackground,
        isScrollControlled: true,
        DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(TSizes().defaultSpace),
                child: Column(
                  children: [
                    MediaContent(
                      allowSelection: allowSelection,
                      alreadySelectedUrls: alreadySelectedUrls ?? [],
                      allowMultipleSelection: allowMultipleSelection,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      return selectedImages;
    } catch (e) {
      TNotificationOverlay.error(context: Get.context!, title: 'Oh Snap', subTitle: e.toString());
      return null;
    }
  }

  /// Images Selection Bottom Sheet
  void uploadImagesPopup(BuildContext context) {
    Get.defaultDialog(backgroundColor: Colors.white, content: const MediaUploader(), barrierDismissible: true, title: TTexts.uploadImages.tr);
  }
}
