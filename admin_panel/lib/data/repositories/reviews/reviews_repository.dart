import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cwt_ecommerce_admin_panel/features/personalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:t_utils/utils/exports.dart';

import '../../../features/product_management/models/product_model.dart';
import '../../../features/product_management/models/product_review_model.dart';
import '../../../utils/constants/text_strings.dart';
import '../../abstract/base_repository.dart';

class ReviewRepository extends TBaseRepositoryController<ReviewModel> {
  // Singleton instance of the ReviewRepository
  static ReviewRepository get instance => Get.find();

  @override
  Future<String> addItem(ReviewModel item) async {
    final result = await db.collection("Reviews").add(item.toJson());
    return result.id;
  }

  @override
  Future<List<ReviewModel>> fetchAllItems() async {
    final snapshot = await db.collection("Reviews").orderBy('createdAt', descending: true).get();
    final result = snapshot.docs.map((e) => ReviewModel.fromDocSnapshot(e)).toList();
    return result;
  }

  @override
  Future<ReviewModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("Reviews").doc(id).get();
    final result = ReviewModel.fromDocSnapshot(snapshot);
    return result;
  }

  @override
  ReviewModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return ReviewModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) => db.collection('Reviews').orderBy('createdAt', descending: true).limit(limit);

  @override
  Future<void> updateItem(ReviewModel item) async {
    await db.collection("Reviews").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Reviews").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(ReviewModel item) async {
    await db.collection("Reviews").doc(item.id).delete();
  }

  /// Add new review with proper details.
  Future<ReviewModel> submitReview({
    required ProductModel product,
    required double rating,
    String? comment,
    bool isApproved = true,
  }) async {
    final user = UserController.instance.user;
    try {
      ReviewModel newReview = ReviewModel.empty();
      final reviewRef = db.collection('Reviews').doc();
      final productRef = db.collection('Products').doc(product.id);
      final userRef = db.collection('Users').doc(user.value.id);

      await db.runTransaction((transaction) async {
        // 1. Retrieve the user document first to obtain user details.
        if (user.value.id.isEmpty) {
          throw Exception(TTexts.userDoesNotExist.tr);
        }

        // 2. Ensure the product exists.
        if (product.id.isEmpty) {
          throw Exception(TTexts.productDoesNotExist.tr);
        }

        // Convert existing lastReviews (List<ReviewModel>) to a list of maps.
        List<dynamic> lastReviewsList = (product.lastReviews ?? []).map((review) => review.toJson()).toList();

        // 4. Create a new ReviewModel instance.
        // (For createdAt and updatedAt, we use DateTime.now() as placeholders.
        // In a production setting, you might choose to rely solely on server timestamps.)
        newReview = ReviewModel(
          id: reviewRef.id,
          productId: product.id,
          productName: product.title,
          productImage: product.thumbnail,
          userId: user.value.id,
          userName: user.value.fullName,
          userProfileImage: user.value.profilePicture,
          rating: rating,
          reviewText: comment ?? '',
          mediaUrls: [],
          isApproved: isApproved,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        // 5. Add the new review document to the Reviews collection.
        transaction.set(reviewRef, newReview.toJson());

        // 6. Calculate new aggregated review values.
        if (rating != 0) product.updateAverageRating(rating);
        product.reviewsCount = product.reviewsCount! + 1;

        // 7. Update the lastReviews list.
        // Insert the new review (as JSON) at the beginning.
        lastReviewsList.insert(0, newReview.toJson());
        // Ensure the list contains only the last 3 reviews.
        if (lastReviewsList.length > 3) {
          lastReviewsList = lastReviewsList.sublist(0, 3);
        }

        // 9. Update the product document with the new aggregated review data.
        transaction.update(productRef, {
          'reviewsCount': product.reviewsCount,
          'ratingCount': product.ratingCount,
          'rating': product.rating,
          'fiveStarCount': product.fiveStarCount,
          'fourStarCount': product.fourStarCount,
          'threeStarCount': product.threeStarCount,
          'twoStarCount': product.twoStarCount,
          'oneStarCount': product.oneStarCount,
          'lastReviews': lastReviewsList,
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        // 10. Update the User document to mark that this user has reviewed this product.
        final List<String> reviewedProducts = user.value.reviewedProducts ?? [];
        if (!reviewedProducts.contains(product.id)) {
          reviewedProducts.add(product.id);
        }

        user.value.reviewedProducts = reviewedProducts;

        transaction.update(userRef, {
          'reviewedProducts': reviewedProducts,
        });

        debugPrint(user.value.toJson().toString());
      });
      return newReview;
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

  /// Delete review with proper handling of the stats
  Future<void> deleteReview({required ReviewModel review, required String productId}) async {
    try {
      // Database references
      final reviewRef = db.collection('Reviews').doc(review.id);
      final productRef = db.collection('Products').doc(productId);
      final userRef = db.collection('Users').doc(UserController.instance.user.value.id);

      await db.runTransaction((transaction) async {

        try {
          final productSnapShot = await transaction.get(productRef);

          // 1. Delete the review from the Reviews collection.
          transaction.delete(reviewRef);

          if (!productSnapShot.exists) {
            // Product not found.
            // Update the User document
            List<String> reviewedProducts = UserController.instance.user.value.reviewedProducts ?? [];
            reviewedProducts.remove(productId);
            transaction.update(userRef, {
              'reviewedProducts': reviewedProducts,
            });

            // Log and return after review deletion.
            debugPrint(TTexts.productNotFoundReviewDeleted.tr);

            return; // Exit the transaction.
          }

          final product = ProductModel.fromDocSnapshot(productSnapShot);

          // 2. Update the Product aggregated fields.
          // Calculate the new review count.
          int currentReviewCount = product.reviewsCount ?? 0;
          int newReviewCount = currentReviewCount - 1;
          int currentRatingCount = product.ratingCount ?? 0;
          int newRatingCount = review.rating != 0 ? currentRatingCount - 1 : currentRatingCount;
          // Guard against negative count.
          newReviewCount = newReviewCount < 0 ? 0 : newReviewCount;
          newRatingCount = newRatingCount < 0 ? 0 : newRatingCount;

          double currentAverageRating = product.rating ?? 0.0;
          double newAverageRating = 0.0;
          if (newReviewCount > 0) {
            newAverageRating = (currentAverageRating * currentReviewCount - review.rating) / newReviewCount;
          }

          // Update star distribution.
          int newFiveStarCount = product.fiveStarCount;
          int newFourStarCount = product.fourStarCount;
          int newThreeStarCount = product.threeStarCount;
          int newTwoStarCount = product.twoStarCount;
          int newOneStarCount = product.oneStarCount;

          int intRating = review.rating.toInt();
          if (intRating >= 5) {
            newFiveStarCount = (newFiveStarCount > 0) ? newFiveStarCount - 1 : 0;
          } else if (intRating == 4) {
            newFourStarCount = (newFourStarCount > 0) ? newFourStarCount - 1 : 0;
          } else if (intRating == 3) {
            newThreeStarCount = (newThreeStarCount > 0) ? newThreeStarCount - 1 : 0;
          } else if (intRating == 2) {
            newTwoStarCount = (newTwoStarCount > 0) ? newTwoStarCount - 1 : 0;
          } else if (intRating <= 1) {
            newOneStarCount = (newOneStarCount > 0) ? newOneStarCount - 1 : 0;
          }

          // Update the lastReviews list by removing the deleted review.
          List<dynamic> lastReviewsList = (product.lastReviews ?? []).map((rev) => rev.toJson()).toList();
          lastReviewsList.removeWhere((revMap) => revMap['reviewId'] == review.id);

          // 3. Update the product document.
          transaction.update(productRef, {
            'reviewsCount': newReviewCount,
            'ratingCount': newRatingCount,
            'rating': newAverageRating,
            'averageRating': newAverageRating,
            'fiveStarCount': newFiveStarCount,
            'fourStarCount': newFourStarCount,
            'threeStarCount': newThreeStarCount,
            'twoStarCount': newTwoStarCount,
            'oneStarCount': newOneStarCount,
            'lastReviews': lastReviewsList,
            'lastUpdated': FieldValue.serverTimestamp(),
          });

          // 4. Update the User document.
          // Remove the product from the user's reviewedProducts list (if the user only reviews once per product).
          List<String> reviewedProducts = UserController.instance.user.value.reviewedProducts ?? [];
          reviewedProducts.remove(product.id);
          transaction.update(userRef, {
            'reviewedProducts': reviewedProducts,
          });
        } catch (e) {
          print(e);
        }
      });
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
      print(e);
      throw 'Something went wrong. Please try again';
    }
  }
}
