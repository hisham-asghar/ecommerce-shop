import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_center.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/presentation/leave_review_page/leave_review_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/presentation/product_reviews/product_rating_bar.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/domain/review.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/application/reviews_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

class LeaveReviewScreen extends ConsumerWidget {
  const LeaveReviewScreen({Key? key, required this.productId})
      : super(key: key);
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<VoidAsyncValue>(
      leaveReviewControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final reviewValue = ref.watch(userReviewProvider(productId));
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.leaveReview),
      ),
      body: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        padding: const EdgeInsets.all(Sizes.p16),
        child: AsyncValueWidget<Review?>(
          value: reviewValue,
          data: (review) =>
              LeaveReviewForm(productId: productId, review: review),
        ),
      ),
    );
  }
}

class LeaveReviewForm extends ConsumerStatefulWidget {
  const LeaveReviewForm({Key? key, required this.productId, this.review})
      : super(key: key);
  final String productId;
  final Review? review;

  static const reviewCommentKey = Key('reviewComment');

  @override
  ConsumerState<LeaveReviewForm> createState() => _LeaveReviewFormState();
}

class _LeaveReviewFormState extends ConsumerState<LeaveReviewForm> {
  final _controller = TextEditingController();

  double _rating = 0;

  @override
  void initState() {
    super.initState();
    if (widget.review != null) {
      _controller.text = widget.review!.comment;
      _rating = widget.review!.score;
    }
  }

  Future<void> _submitReview() async {
    // only submit if new rating or different from before
    final previousReview = widget.review;
    if (previousReview == null ||
        _rating != previousReview.score ||
        _controller.text != previousReview.comment) {
      await ref.read(leaveReviewControllerProvider.notifier).submitReview(
            productId: widget.productId,
            comment: _controller.text,
            score: _rating,
          );
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    // error handling
    final state = ref.watch(leaveReviewControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.review != null) ...[
          Text(
            context.loc.previouslyReviewedHint,
            textAlign: TextAlign.center,
          ),
          gapH24,
        ],
        Center(
          child: ProductRatingBar(
            initialRating: _rating,
            onRatingUpdate: (rating) => setState(() => _rating = rating),
          ),
        ),
        gapH32,
        TextField(
          key: LeaveReviewForm.reviewCommentKey,
          controller: _controller,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: context.loc.yourReviewHint,
            border: const OutlineInputBorder(),
          ),
        ),
        gapH32,
        PrimaryButton(
          text: context.loc.submit,
          isLoading: state.isLoading,
          onPressed: state.isLoading || _rating == 0 ? null : _submitReview,
        )
      ],
    );
  }
}
