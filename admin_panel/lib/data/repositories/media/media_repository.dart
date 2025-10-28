import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';

import '../../../features/media/models/image_model.dart';
import '../../../utils/constants/text_strings.dart';

class MediaRepository extends GetxController {
  static MediaRepository get instance => Get.find();

  /// Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload any Image using Uint8List (compatible with DropzoneFileInterface)
  Future<ImageModel> uploadImageFileInStorage(
      {required Uint8List fileData, required String mimeType, required String path, required String imageName}) async {
    try {
      // Reference to the storage location
      final Reference ref = _storage.ref('$path/$imageName');

      // Upload file using Uint8List
      final UploadTask uploadTask = ref.putData(fileData, SettableMetadata(contentType: mimeType));

      // Wait for the upload to complete
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});

      // Get download URL
      final String downloadURL = await snapshot.ref.getDownloadURL();

      // Fetch metadata
      final FullMetadata metadata = await ref.getMetadata();

      return ImageModel.fromFirebaseMetadata(path, imageName, downloadURL, metadata: metadata);
    } catch (e) {
      throw handleAuthException(e);
    }
  }

  /// Upload Image data in Firestore
  Future<String> uploadImageFileInDatabase(ImageModel image) async {
    try {
      final data = await FirebaseFirestore.instance.collection("Images").add(image.toJson());
      return data.id;
    } catch (e) {
      throw handleAuthException(e);
    }
  }

  // Fetch images from Firestore based on media category and load count
  Future<List<ImageModel>> fetchImagesFromDatabase(MediaCategory mediaCategory, int loadCount) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("Images")
          .where("mediaCategory", isEqualTo: mediaCategory.name.toString())
          .orderBy("createdAt", descending: true)
          .limit(loadCount)
          .get();

      return querySnapshot.docs.map((e) => ImageModel.fromSnapshot(e)).toList();
    } catch (e) {
      throw handleAuthException(e);
    }
  }

  // Load more images from Firestore based on media category, load count, and last fetched date
  Future<List<ImageModel>> loadMoreImagesFromDatabase(MediaCategory mediaCategory, int loadCount, DateTime lastFetchedDate) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("Images")
          .where("mediaCategory", isEqualTo: mediaCategory.name.toString())
          .orderBy("createdAt", descending: true)
          .startAfter([lastFetchedDate])
          .limit(loadCount)
          .get();

      return querySnapshot.docs.map((e) => ImageModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      // If index is required to be created
      if (e.code == 'failed-precondition') {
        TDialogs.defaultDialog(
          context: Get.context!,
          title: 'Create new Index',
          content: SelectableText(e.message ?? 'The query requires an index. Create that index and try again.'),
        );
        throw 'The query requires an index. Create that index and try again.';
      }

      throw e.message!;
    } catch (e) {
      throw handleAuthException(e);
    }
  }

  // Fetch all images from Firebase Storage
  Future<List<ImageModel>> fetchAllImages() async {
    try {
      final ListResult result = await _storage.ref().listAll();
      final List<ImageModel> images = [];

      for (final Reference ref in result.items) {
        final String filename = ref.name;

        // Fetch download URL
        final String downloadURL = await ref.getDownloadURL();

        // Fetch metadata
        final FullMetadata metadata = await ref.getMetadata();

        images.add(ImageModel.fromFirebaseMetadata('', filename, downloadURL, metadata: metadata));
      }

      return images;
    } catch (e) {
      throw handleAuthException(e);
    }
  }

  // Delete file from Firebase Storage and corresponding document from Firestore
  Future<void> deleteFileFromStorage(ImageModel image) async {
    try {
      // Check if file exists in Firebase Storage
      final ref = FirebaseStorage.instance.ref(image.fullPath);
      bool fileExists = false;

      try {
        await ref.getDownloadURL();
        fileExists = true;
      } on FirebaseException catch (e) {
        if (e.code == 'object-not-found') {
          fileExists = false;
        } else {
          throw e.message ?? TTexts.errorVerifyingFileExistence.tr;
        }
      }

      // Delete the file if it exists
      if (fileExists) {
        await ref.delete();
      }

      // Delete corresponding Firestore document
      await FirebaseFirestore.instance.collection('Images').doc(image.id).delete();
    } catch (e) {
      throw handleAuthException(e);
    }
  }

  String handleAuthException(e) {
    if (e is FirebaseAuthException) {
      // If index is required to be created
      if (e.code == 'failed-precondition') {
        TDialogs.defaultDialog(
          context: Get.context!,
          title: 'Create new Index',
          content: SelectableText(e.message ?? TTexts.queryRequiresIndex.tr),
        );
        return TTexts.queryRequiresIndex.tr;
      }

      return TFirebaseAuthException(e.code).message;
    } else if (e is FirebaseException) {
      return TFirebaseException(e.code).message;
    } else if (e is FormatException) {
      return const TFormatException().message;
    } else if (e is PlatformException) {
      return TPlatformException(e.code).message;
    } else {
      return e;
    }
  }
}
