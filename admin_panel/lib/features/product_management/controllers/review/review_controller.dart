import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/reviews/reviews_repository.dart';
import '../../models/product_review_model.dart';

class ReviewController extends TBaseTableController<ReviewModel> {
  static ReviewController get instance => Get.find();

  // Inject the repository
  final ReviewRepository reviewRepository = Get.put(ReviewRepository());

  @override
  Future<List<ReviewModel>> fetchItems() async {
    // To make sure add more items button is not visible (allFetchedItems < limit)
    limit.value = 10000000;
    return await reviewRepository.getAllItems();
  }

  @override
  bool containsSearchQuery(ReviewModel item, String query) {
    return item.reviewText.toLowerCase().contains(query.toLowerCase()) ||
        item.productName.toLowerCase().contains(query.toLowerCase()) ||
        item.userName.toLowerCase().contains(query.toLowerCase());
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (ReviewModel category) => category.reviewText.toLowerCase());
  }

  @override
  Future<ReviewModel?> updateStatusToggleSwitch(bool toggle, ReviewModel item) async {
    if (item.isApproved == toggle) return null;

    item.isApproved = toggle;
    await reviewRepository.updateSingleItemRecord(item.id, {'isApproved': toggle});
    return item;
  }

  @override
  Future<ReviewModel?> updateFeaturedToggleSwitch(bool toggle, ReviewModel item) async {
    return item;
  }

  @override
  Future<void> deleteItem(ReviewModel item) async {
    // Now, delete the brand itself
    await reviewRepository.deleteReview(review: item, productId: item.productId);
  }
}
