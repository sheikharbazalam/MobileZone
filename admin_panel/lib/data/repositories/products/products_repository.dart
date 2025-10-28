import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/product_management/models/product_model.dart';

import 'package:t_utils/t_utils.dart';
import '../../../utils/constants/text_strings.dart';
import '../../abstract/base_repository.dart';

class ProductRepository extends TBaseRepositoryController<ProductModel> {
  // Singleton instance of the ProductRepository
  static ProductRepository get instance => Get.find();

  @override
  Future<String> addItem(ProductModel item) async {
    final batch = db.batch();

    // Reference to add the product in the Products collection
    final result = await db.collection("Products").add(item.toJson());

    // Increment Brand product count if a brand is associated with the product
    if (item.brand != null && item.brand!.id.isNotEmpty) {
      final brandRef = db.collection('Brands').doc(item.brand!.id);
      batch.update(brandRef, {'productsCount': FieldValue.increment(1)});
    }

    // Increment each Category's product count if categories are associated with the product
    if (item.categoryIds != null) {
      for (String categoryId in item.categoryIds!) {
        final categoryRef = db.collection('Categories').doc(categoryId);
        batch.update(categoryRef, {'numberOfProducts': FieldValue.increment(1)});
      }
    }

    // Increment Retailer's totalProducts if a retailer is associated with the product

    // Commit all changes in the batch to apply updates atomically
    await batch.commit();

    return result.id;
  }

  @override
  Future<List<ProductModel>> fetchAllItems() async {
    final snapshot = await db.collection("Products").orderBy('createdAt', descending: true).get();
    final result = snapshot.docs.map((e) => ProductModel.fromDocSnapshot(e)).toList();
    return result;
  }

  @override
  Future<ProductModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("Products").doc(id).get();
    final result = ProductModel.fromDocSnapshot(snapshot);
    return result;
  }

  @override
  ProductModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return ProductModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('Products').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(ProductModel item) async {
    await db.collection("Products").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Products").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(ProductModel item) async {
    // Reduce the Brand and Categories Count (-1) when deleting a product
    final brandId = item.brand?.id;
    final categoryIds = item.categoryIds ?? [];

    // Begin a batch operation to handle all updates atomically
    final batch = db.batch();

    // Update the brand's product count if a brand is associated with the product
    if (brandId != null) {
      final brandRef = db.collection('Brands').doc(brandId);
      batch.update(brandRef, {'productsCount': FieldValue.increment(-1)});
    }

    // Update each category's product count
    for (String categoryId in categoryIds) {
      final categoryRef = db.collection('Categories').doc(categoryId);
      batch.update(categoryRef, {'numberOfProducts': FieldValue.increment(-1)});
    }

    // Delete Product
    batch.delete(db.collection("Products").doc(item.id));

    // Commit the batch update to apply all changes atomically
    await batch.commit();
  }

  Future<List<ProductModel>> getAllRetailerProducts(String retailerId) async {
    try {
      final snapshot = await db.collection("Products").where('retailerId', isEqualTo: retailerId).get();
      final result = snapshot.docs.map((e) => ProductModel.fromDocSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw TTexts.somethingWentWrong.tr;
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final lowerQuery = query.toLowerCase();

    // Initialize a set to track unique product IDs
    final Set<String> productIds = {};
    final List<ProductModel> allResults = [];

    try {
      // 1. Search by tags
      QuerySnapshot tagsQuery = await db
          .collection('Products')
          .where('tags', arrayContains: lowerQuery)
          .where('isActive', isEqualTo: true)
          .where('isDraft', isEqualTo: false)
          .where('isDeleted', isEqualTo: false)
          .limit(5)
          .get();

      for (var doc in tagsQuery.docs) {
        final product = ProductModel.fromQuerySnapshot(doc);
        if (!productIds.contains(product.id)) {
          productIds.add(product.id);
          allResults.add(product);
        }
      }

      // 2. Search by title (prefix match) if needed
      final remaining = 5 - allResults.length;
      if (remaining > 0) {
        QuerySnapshot titleQuery = await db
            .collection('Products')
            .where('lowerTitle', isGreaterThanOrEqualTo: lowerQuery)
            .where('lowerTitle', isLessThanOrEqualTo: '$lowerQuery\uf8ff')
            .where('isActive', isEqualTo: true)
            .where('isDraft', isEqualTo: false)
            .where('isDeleted', isEqualTo: false)
            .orderBy('title')
            .limit(remaining)
            .get();

        for (var doc in titleQuery.docs) {
          final product = ProductModel.fromQuerySnapshot(doc);
          if (!productIds.contains(product.id)) {
            productIds.add(product.id);
            allResults.add(product);
          }
        }
      }

      // Return up to 5 results
      return allResults.take(5).toList();
    } on FirebaseException catch (e) {
      // If index is required to be created
      if (e.code == 'failed-precondition') {
        TDialogs.defaultDialog(
          context: Get.context!,
          title: 'Create new Index',
          content: SelectableText(e.message ?? TTexts.queryRequiresIndex.tr),
        );
      }

      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw TTexts.somethingWentWrong.tr;
    }
  }
}
