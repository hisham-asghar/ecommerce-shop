import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/purchase.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/review.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/reviews_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';
import 'package:rxdart/rxdart.dart';

class FakeReviewsRepository implements ReviewsRepository {
  FakeReviewsRepository({this.addDelay = true});
  final bool addDelay;

  // productId -> uid -> Purchase
  Map<String, Map<String, Purchase>> purchasesData = {};
  final _purchasesDataSubject =
      BehaviorSubject<Map<String, Map<String, Purchase>>>.seeded({});
  Stream<Map<String, Map<String, Purchase>>> get _purchasesDataStream =>
      _purchasesDataSubject.stream;

  Future<void> addPurchase({
    required String productId,
    required String uid,
    required Purchase purchase,
  }) async {
    await delay(addDelay);
    final productPurchases = purchasesData[productId];
    if (productPurchases != null) {
      // purchases already exist: set the new purchase for the given uid
      productPurchases[uid] = purchase;
    } else {
      // purchases do not exist: create a new map with the new purchase
      purchasesData[productId] = {uid: purchase};
    }
    _purchasesDataSubject.add(purchasesData);
  }

  @override
  Stream<Purchase?> userPurchase(String id, String uid) {
    return _purchasesDataStream.map((purchasesData) {
      // access nested maps by productId, then uid
      return purchasesData[id]?[uid];
    });
  }

  // productId -> uid -> Purchase
  Map<String, Map<String, Review>> reviewsData = {};
  final _reviewsDataSubject =
      BehaviorSubject<Map<String, Map<String, Review>>>.seeded({});
  Stream<Map<String, Map<String, Review>>> get _reviewsDataStream =>
      _reviewsDataSubject.stream;

  @override
  Stream<Review?> userReview(String id, String uid) {
    return _reviewsDataStream.map((reviewsData) {
      // access nested maps by productId, then uid
      return reviewsData[id]?[uid];
    });
  }

  @override
  Future<void> submitReview({
    required String productId,
    required String uid,
    required Review review,
  }) async {
    await delay(addDelay);
    final reviews = reviewsData[productId];
    if (reviews != null) {
      // purchases already exist: set the new purchase for the given uid
      reviews[uid] = review;
    } else {
      // purchases do not exist: create a new map with the new purchase
      reviewsData[productId] = {uid: review};
    }
    _reviewsDataSubject.add(reviewsData);
  }

  @override
  Stream<List<Review>> reviews(String id) {
    return _reviewsDataStream.map((reviewsData) {
      // access nested maps by productId, then uid
      final reviews = reviewsData[id];
      if (reviews == null) {
        return [];
      } else {
        return reviews.values.toList();
      }
    });
  }
}
