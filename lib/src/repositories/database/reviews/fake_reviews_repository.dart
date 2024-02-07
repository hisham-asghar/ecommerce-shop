import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/purchase.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/review.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/reviews_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/in_memory_store.dart';

class FakeReviewsRepository implements ReviewsRepository {
  FakeReviewsRepository({this.addDelay = true});
  final bool addDelay;

  // Purchases Store
  // productId -> uid -> Purchase
  final _purchases = InMemoryStore<Map<String, Map<String, Purchase>>>({});

  // * Note: this is not an overridden method. It is only called explicitly
  // * by the FakeOrdersRepository.
  Future<void> addPurchase({
    required String productId,
    required String uid,
    required Purchase purchase,
  }) async {
    await delay(addDelay);
    final value = _purchases.value;
    final productPurchases = value[productId];
    if (productPurchases != null) {
      // purchases already exist: set the new purchase for the given uid
      productPurchases[uid] = purchase;
    } else {
      // purchases do not exist: create a new map with the new purchase
      value[productId] = {uid: purchase};
    }
    _purchases.value = value;
  }

  @override
  Stream<Purchase?> watchUserPurchase(String id, String uid) {
    return _purchases.stream.map((purchasesData) {
      // access nested maps by productId, then uid
      return purchasesData[id]?[uid];
    });
  }

  // Reviews Store

  final _reviews = InMemoryStore<Map<String, Map<String, Review>>>({});

  @override
  Stream<Review?> watchUserReview(String id, String uid) {
    return _reviews.stream.map((reviewsData) {
      // access nested maps by productId, then uid
      return reviewsData[id]?[uid];
    });
  }

  @override
  Stream<List<Review>> watchReviews(String id) {
    return _reviews.stream.map((reviewsData) {
      // access nested maps by productId, then uid
      final reviews = reviewsData[id];
      if (reviews == null) {
        return [];
      } else {
        return reviews.values.toList();
      }
    });
  }

  @override
  Future<void> setReview({
    required String productId,
    required String uid,
    required Review review,
  }) async {
    await delay(addDelay);
    final value = _reviews.value;
    final reviews = value[productId];
    if (reviews != null) {
      // purchases already exist: set the new purchase for the given uid
      reviews[uid] = review;
    } else {
      // purchases do not exist: create a new map with the new purchase
      value[productId] = {uid: review};
    }
    _reviews.value = value;
  }
}
