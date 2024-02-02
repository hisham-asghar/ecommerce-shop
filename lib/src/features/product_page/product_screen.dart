import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/centered_box.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/home_app_bar/home_app_bar.dart';
import 'package:my_shop_ecommerce_flutter/src/features/not_found/not_found_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/product_average_rating.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/product_reviews/product_reviews_list.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/leave_review_action.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/products_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/currency_formatter.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({Key? key, required this.productId}) : super(key: key);
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(productProvider(productId));
    return Scaffold(
      appBar: const HomeAppBar(),
      body: AsyncValueWidget<Product?>(
        value: productValue,
        data: (product) => product == null
            ? const NotFoundWidget()
            : CustomScrollView(
                slivers: [
                  CenteredSliverToBoxAdapter(
                    padding: const EdgeInsets.all(Sizes.p16),
                    child: ProductDetails(product: product),
                  ),
                  ProductReviewsList(productId: productId),
                ],
              ),
      ),
    );
  }
}

class ProductDetails extends ConsumerWidget {
  const ProductDetails({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceFormatted =
        ref.watch(currencyFormatterProvider).format(product.price);
    return ResponsiveTwoColumnLayout(
      startContent: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          // TODO: Handle CORS https://flutter.dev/docs/development/platform-integration/web-images
          child: CachedNetworkImage(imageUrl: product.imageUrl),
        ),
      ),
      spacing: Sizes.p16,
      endContent: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(product.title, style: Theme.of(context).textTheme.headline6),
              gapH8,
              Text(product.description),
              if (product.numRatings >= 1) ...[
                gapH8,
                ProductAverageRating(product: product),
              ],
              gapH8,
              const Divider(),
              gapH8,
              Text(priceFormatted,
                  style: Theme.of(context).textTheme.headline5),
              gapH8,
              LeaveReviewAction(productId: product.id),
              const Divider(),
              gapH8,
              AddToCartWidget(product: product),
            ],
          ),
        ),
      ),
    );
  }
}
