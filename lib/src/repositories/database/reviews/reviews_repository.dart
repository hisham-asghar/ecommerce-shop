import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/purchase.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/review.dart';

abstract class ReviewsRepository {
  /// Product purchase information for a given user
  /// This can be used to show the purchase date in the product page UI,
  /// given the productId and the user uid
  Stream<Purchase?> userPurchase(String productId, String uid);

  /// Review information for a given product
  /// This stream emits non-null values when the user has reviewed the product
  Stream<Review?> userReview(String productId, String uid);

  /// Submit a new review or update an existing review for a given product
  /// @param productId the product identifier
  /// @param uid the identifier of the user who is leaving the review
  /// @param review a Review object with the review information
  Future<void> submitReview({
    required String productId,
    required String uid,
    required Review review,
  });

  /// All reviews by all users for a given product
  Stream<List<Review>> reviews(String id);
}

final reviewsRepositoryProvider = Provider<ReviewsRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
