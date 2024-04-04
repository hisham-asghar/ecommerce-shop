import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/data/reviews_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/domain/purchase.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/domain/review.dart';

class FirebaseReviewsRepository implements ReviewsRepository {
  FirebaseReviewsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String purchasePath(String id, String uid) =>
      'products/$id/purchases/$uid';
  static String reviewPath(String id, String uid) =>
      'products/$id/reviews/$uid';
  static String reviewsPath(String id) => 'products/$id/reviews';

  @override
  Stream<Purchase?> watchUserPurchase(String id, String uid) {
    final ref = _purchaseRef(id, uid);
    return ref.snapshots().map((snapshot) => snapshot.data());
  }

  @override
  Stream<Review?> watchUserReview(String id, String uid) {
    final ref = _reviewRef(id, uid);
    return ref.snapshots().map((snapshot) => snapshot.data());
  }

  @override
  Stream<List<Review>> watchReviews(String id) {
    final ref = _reviewsRef(id);
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  @override
  Future<void> setReview({
    required String productId,
    required String uid,
    required Review review,
  }) {
    final ref = _reviewRef(productId, uid);
    return ref.set(review);
  }

  DocumentReference<Purchase?> _purchaseRef(String id, String uid) =>
      _firestore.doc(purchasePath(id, uid)).withConverter(
            fromFirestore: (doc, _) =>
                doc.exists ? Purchase.fromMap(doc.data()!) : null,
            toFirestore: (Purchase? purchase, options) =>
                purchase != null ? purchase.toMap() : {},
          );

  DocumentReference<Review?> _reviewRef(String id, String uid) =>
      _firestore.doc(reviewPath(id, uid)).withConverter(
            fromFirestore: (doc, _) =>
                doc.exists ? Review.fromMap(doc.data()!) : null,
            toFirestore: (Review? review, options) =>
                review != null ? review.toMap() : {},
          );

  Query<Review> _reviewsRef(String id) => _firestore
      .collection(reviewsPath(id))
      .orderBy('date', descending: true)
      .withConverter(
        fromFirestore: (doc, _) => Review.fromMap(doc.data()!),
        toFirestore: (Review review, options) => review.toMap(),
      );
}
