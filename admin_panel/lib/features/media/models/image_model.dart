import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cwt_ecommerce_admin_panel/features/personalization/controllers/user_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:t_utils/t_utils.dart';

import '../../../utils/constants/enums.dart';

/// Model class representing user data.
class ImageModel {
  String id;
  final String url;
  final String folder;
  final int? sizeBytes;
  String mediaCategory;
  final String filename;
  final String? fullPath;
  final String uploadedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? contentType;
  StorageType? storageType;

  // Not Mapped
  // final File? file;
  RxBool isSelected = false.obs;
  final Uint8List? localImageToDisplay;

  /// Constructor for ImageModel.
  ImageModel({
    this.id = '',
    required this.url,
    required this.folder,
    required this.filename,
    required this.uploadedBy,
    this.sizeBytes,
    this.fullPath,
    this.createdAt,
    this.updatedAt,
    this.contentType,
    // this.file,
    this.localImageToDisplay,
    this.mediaCategory = '',
    this.storageType,
  });

  /// Static function to create an empty user model.
  static ImageModel empty() => ImageModel(url: '', folder: '', filename: '', uploadedBy: '');

  String get createdAtFormatted => TFormatter.formatDateAndTime(createdAt);

  String get updatedAtFormatted => TFormatter.formatDateAndTime(updatedAt);

  /// Convert to Json to Store in DB
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'folder': folder,
      'sizeBytes': sizeBytes,
      'filename': filename,
      'fullPath': fullPath,
      'createdAt': createdAt?.toUtc(),
      'contentType': contentType,
      'mediaCategory': mediaCategory,
      'uploadedBy': uploadedBy,
      'storageType': storageType?.name,
    };
  }

  /// Convert Firestore Json and Map on Model
  factory ImageModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      // Map JSON Record to the Model
      return ImageModel(
        id: document.id,
        url: data['url'] ?? '',
        folder: data['folder'] ?? '',
        sizeBytes: data['sizeBytes'] ?? 0,
        filename: data['filename'] ?? '',
        fullPath: data['fullPath'] ?? '',
        createdAt: data.containsKey('createdAt') ? data['createdAt']?.toDate() : null,
        updatedAt: data.containsKey('updatedAt') ? data['updatedAt']?.toDate() : null,
        contentType: data['contentType'] ?? '',
        mediaCategory: data['mediaCategory'],
        uploadedBy: data.containsKey('uploadedBy') ? data['uploadedBy'] ?? '' : '',
        storageType: data.containsKey('storageType')
            ? (data['storageType'] ?? '') == StorageType.firebase.name
                ? StorageType.firebase
                : StorageType.supabase
            : null,
      );
    } else {
      return ImageModel.empty();
    }
  }

  /// Map Firebase Storage Data
  factory ImageModel.fromFirebaseMetadata(String folder, String filename, String downloadUrl,
      {FullMetadata? metadata, String? contentType, String? fullPath}) {
    return ImageModel(
      url: downloadUrl,
      folder: folder,
      filename: filename,
      uploadedBy: UserController.instance.user.value.id,
      sizeBytes: metadata?.size,
      updatedAt: metadata?.updated,
      fullPath: fullPath ?? metadata?.fullPath,
      createdAt: metadata == null ? DateTime.now() : metadata.timeCreated,
      contentType: contentType ?? metadata?.contentType,
    );
  }
}
