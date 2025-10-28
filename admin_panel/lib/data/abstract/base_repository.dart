import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';

/// A generic controller class for managing data tables using GetX state management.
/// This class provides common functionalities for handling data tables, including fetching, updating, and deleting items.
abstract class TBaseRepositoryController<T> extends GetxController {
  final db = FirebaseFirestore.instance;

  // Variable to store the last document fetched for pagination
  QueryDocumentSnapshot? lastFetchedDocument;

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<List<T>> fetchAllItems();

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<T> fetchSingleItem(String id);

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<String> addItem(T item);

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<void> updateItem(T item);

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<void> updateSingleField(String id, Map<String, dynamic> json);

  /// Abstract method to be implemented by subclasses for deleting an item.
  Future<void> deleteItem(T item);

  // Get all items from Firestore
  Future<List<T>> getAllItems() async {
    try {
      return await fetchAllItems();
    } on FirebaseException catch (e) {
      // If index is required to be created
      if (e.code == 'failed-precondition') {
        TDialogs.defaultDialog(
          context: Get.context!,
          title: 'Create new Index',
          content: SelectableText(e.message ?? 'The query requires an index. Create that index and try again.'),
        );
      }

      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw handleAuthException(e);
    }
  }

  // Get single item from Firestore
  Future<T> getSingleItem(String id) async {
    try {
      return await fetchSingleItem(id);
    } on FirebaseException catch (e) {
      // If index is required to be created
      if (e.code == 'failed-precondition') {
        TDialogs.defaultDialog(
          context: Get.context!,
          title: 'Create new Index',
          content: SelectableText(e.message ?? 'The query requires an index. Create that index and try again.'),
        );
      }

      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw handleAuthException(e);
    }
  }

  Future<String> addNewItem(T item) async {
    try {
      return await addItem(item);
    } catch (e) {
      throw handleAuthException(e);
    }
  }

  Future<void> updateItemRecord(T item) async {
    try {
      return await updateItem(item);
    } catch (e) {
      throw handleAuthException(e);
    }
  }

  Future<void> updateSingleItemRecord(String id, Map<String, dynamic> json) async {
    try {
      return await updateSingleField(id, json);
    } catch (e) {
      throw handleAuthException(e);
    }
  }

  Future<void> deleteItemRecord(T item) async {
    try {
      return await deleteItem(item);
    } catch (e) {
      throw handleAuthException(e);
    }
  }

  // Paginated fetching method
  Future<List<T>> fetchPaginatedItems(int limit) async {
    try {
      Query query = getPaginatedQuery(limit);

      // If there's a last fetched document, start after it
      if (lastFetchedDocument != null) {
        query = query.startAfterDocument(lastFetchedDocument!);
      }

      // Fetch the data
      final querySnapshot = await query.get();

      // If there are documents, store the last one for pagination
      if (querySnapshot.docs.isNotEmpty) {
        lastFetchedDocument = querySnapshot.docs.last;
      }

      // Convert to model list
      final items = querySnapshot.docs.map((doc) => fromQueryDocSnapshot(doc)).toList();

      return items;
    } on FirebaseException catch (e) {
      // If index is required to be created
      if (e.code == 'failed-precondition') {
        TDialogs.defaultDialog(
          context: Get.context!,
          title: 'Create new Index',
          content: SelectableText(e.message ?? 'The query requires an index. Create that index and try again.'),
        );
      }

      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw handleAuthException(e);
    }
  }

  // Abstract method to get the collection path
  Query getPaginatedQuery(int limit);

  // Abstract method to convert DocumentSnapshot to model
  T fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc);

  String handleAuthException(e) {
    if (e is FirebaseAuthException) {
      return TFirebaseAuthException(e.code).message;
    } else if (e is FirebaseException) {
      return TFirebaseException(e.code).message;
    } else if (e is FormatException) {
      return const TFormatException().message;
    } else if (e is PlatformException) {
      return TPlatformException(e.code).message;
    } else {
      return 'Something went wrong. Please try again';
    }
  }
}
