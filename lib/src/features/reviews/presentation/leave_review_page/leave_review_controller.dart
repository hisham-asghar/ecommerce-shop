import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_provider.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/domain/review.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/application/reviews_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/current_date_provider.dart';

class LeaveReviewController extends StateNotifier<VoidAsyncValue> {
  LeaveReviewController({
    required this.localizations,
    required this.reviewsService,
    required this.dateTimeFunction,
  }) : super(const VoidAsyncValue.data(null));
  final AppLocalizations localizations;
  final ReviewsService reviewsService;
  final DateTime Function() dateTimeFunction;

  Future<void> submitReview(
      {required double score,
      String? comment,
      required String productId}) async {
    try {
      state = const VoidAsyncValue.loading();
      final review = Review(
        score: score,
        comment: comment ?? '',
        date: dateTimeFunction(),
      );
      await reviewsService.submitReview(productId: productId, review: review);
      state = const VoidAsyncValue.data(null);
    } catch (error, _) {
      state = VoidAsyncValue.error(error);
    }
  }
}

final leaveReviewControllerProvider =
    StateNotifierProvider.autoDispose<LeaveReviewController, VoidAsyncValue>(
        (ref) {
  final localizations = ref.watch(appLocalizationsProvider);
  final reviewsService = ref.watch(reviewsServiceProvider);
  final dateTimeFunction = ref.watch(currentDateFunctionProvider);
  return LeaveReviewController(
    localizations: localizations,
    reviewsService: reviewsService,
    dateTimeFunction: dateTimeFunction,
  );
});
