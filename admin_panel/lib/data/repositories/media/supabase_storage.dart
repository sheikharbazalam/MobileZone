import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/media/models/image_model.dart';
import '../../../utils/constants/text_strings.dart';

/// Supabase Implementation
class SupabaseStorageService extends GetxController {
  static SupabaseStorageService get instance => Get.isRegistered() ? Get.find() : Get.put(SupabaseStorageService());

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Upload Image to Supabase Storage and Get URL.
  Future<ImageModel> uploadImage(
      {required Uint8List fileData, required String path, required String fileName, required String mimeType}) async {
    try {
      // Create Path
      final fullPath = '$path/$fileName';

      // Upload Image
      await _supabase.storage.from('ecommerce-app').uploadBinary(fullPath, fileData, fileOptions: FileOptions(contentType: mimeType));

      // Get download URL
      final String downloadURL = await getDownloadUrl(fullPath);

      // Return
      return ImageModel.fromFirebaseMetadata(path, fileName, downloadURL, contentType: mimeType, fullPath: fullPath);
    } on StorageException catch (e) {
      throw _handleSupabaseError(e);
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e);
    }
  }

  // Get Public URL for Image from Supabase Storage.
  Future<String> getDownloadUrl(String fullPath) async {
    return _supabase.storage.from('ecommerce-app').getPublicUrl(fullPath);
  }

  // Delete Image from Supabase Storage.
  Future<void> deleteImage(ImageModel image) async {
    try {
      if (image.fullPath == null || image.fullPath!.isEmpty) {
        throw 'Invalid image path: ${image.fullPath}';
      }

      // 1. Verify Supabase path format
      final supabasePath = image.fullPath!.substring(1);
      debugPrint('Attempting to delete from Supabase: $supabasePath');

      // 2. Enhanced existence check
      final bool fileExists = await _supabase.storage
          .from('ecommerce-app')
          .exists(supabasePath);

      debugPrint('File existence check result: $fileExists');

      // 3. Attempt deletion if exists
      if (fileExists) {
        debugPrint('Initiating Supabase deletion...');
        final deletionResult = await _supabase.storage
            .from('ecommerce-app')
            .remove([supabasePath]);

        debugPrint('Deletion response: $deletionResult');

        // Verify post-deletion existence
        final postDeletionExist = await _supabase.storage
            .from('ecommerce-app')
            .exists(supabasePath);

        if (postDeletionExist) {
          throw 'File still exists after deletion attempt: $supabasePath';
        }
      }

      // 4. Firestore cleanup
      debugPrint('Deleting Firestore document: ${image.id}');
      await FirebaseFirestore.instance
          .collection('Images')
          .doc(image.id)
          .delete();
    } on StorageException catch (e) {
      throw _handleSupabaseError(e);
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e);
    }
  }

  // Error handling helpers
  Exception _handleSupabaseError(StorageException e) {
    return Exception('${TTexts.supabaseStorageError.tr}(${e.statusCode}):  ${e.message}');
  }

  Exception _handleFirestoreError(FirebaseException e) {
    return Exception('${TTexts.firestoreError.tr}(${e.code}):  ${e.message} - ${e.stackTrace}');
  }
}
