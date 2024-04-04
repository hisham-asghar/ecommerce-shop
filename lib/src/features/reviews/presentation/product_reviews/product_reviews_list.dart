import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_center.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/domain/review.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/application/reviews_service.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/presentation/product_reviews/product_review_card.dart';

/// Shows the list of reviews for a given product ID
class ProductReviewsList extends ConsumerWidget {
  const ProductReviewsList({Key? key, required this.productId})
      : super(key: key);
  final String productId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsValue = ref.watch(productReviewsProvider(productId));
    return AsyncValueSliverWidget<List<Review>>(
      value: reviewsValue,
      data: (reviews) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => ResponsiveCenter(
            maxContentWidth: Breakpoint.tablet,
            padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p16, vertical: Sizes.p8),
            child: ProductReviewCard(reviews[index]),
          ),
          childCount: reviews.length,
        ),
      ),
    );
  }
}
