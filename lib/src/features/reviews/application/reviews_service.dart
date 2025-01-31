import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:my_shop_ecommerce_flutter/src/exceptions/app_exception.dart';
import 'package:my_shop_ecommerce_flutter/src/exceptions/run_catching_exceptions.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/data/reviews_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/domain/purchase.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/domain/review.dart';

class ReviewsService {
  ReviewsService(
      {required this.reviewsRepository, required this.authRepository});
  final ReviewsRepository reviewsRepository;
  final AuthRepository authRepository;

  Stream<Review?> userReview(String productId) {
    final user = authRepository.currentUser;
    if (user != null) {
      return reviewsRepository.watchUserReview(productId, user.uid);
    } else {
      return Stream.value(null);
    }
  }

  Future<Result<AppException, void>> submitReview(
          {required String productId, required Review review}) =>
      runCatchingExceptions(() async {
        final user = authRepository.currentUser!;
        await reviewsRepository.setReview(
          productId: productId,
          uid: user.uid,
          review: review,
        );
      });
}

final reviewsServiceProvider = Provider<ReviewsService>((ref) {
  final reviewsRepository = ref.watch(reviewsRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return ReviewsService(
    reviewsRepository: reviewsRepository,
    authRepository: authRepository,
  );
});

final userReviewProvider =
    StreamProvider.autoDispose.family<Review?, String>((ref, productId) {
  final reviewsService = ref.watch(reviewsServiceProvider);
  return reviewsService.userReview(productId);
});

final userPurchaseProvider =
    StreamProvider.autoDispose.family<Purchase?, String>((ref, id) {
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.value;
  if (user != null) {
    final reviewsRepository = ref.watch(reviewsRepositoryProvider);
    return reviewsRepository.watchUserPurchase(id, user.uid);
  } else {
    return Stream.value(null);
  }
});

final productReviewsProvider =
    StreamProvider.autoDispose.family<List<Review>, String>((ref, productId) {
  final reviewsRepository = ref.watch(reviewsRepositoryProvider);
  return reviewsRepository.watchReviews(productId);
});
