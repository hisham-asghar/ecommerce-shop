import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/presentation/leave_review_page/leave_review_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/presentation/product_reviews/product_review_card.dart';

class ReviewsRobot {
  ReviewsRobot(this.tester);
  final WidgetTester tester;

  void expectFindLeaveReview() {
    final finder = find.text('Leave a review');
    expect(finder, findsOneWidget);
  }

  Future<void> leaveReview() async {
    final finder = find.text('Leave a review');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  void expectFindOneReview() {
    final finder = find.byType(ProductReviewCard);
    expect(finder, findsOneWidget);
  }

  // leave a review
  Future<void> selectReviewScore() async {
    final finder = find.byKey(const Key('stars-4'));
    expect(finder, findsOneWidget);
    await tester.tap(finder);
  }

  Future<void> enterReviewComment() async {
    final finder = find.byKey(LeaveReviewForm.reviewCommentKey);
    expect(finder, findsOneWidget);
    await tester.enterText(finder, 'Love it!');
  }

  Future<void> submitReview() async {
    final finder = find.text('Submit');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> createAndSubmitReview() async {
    await selectReviewScore();
    await enterReviewComment();
    await submitReview();
  }
}
