import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/home_app_bar/home_app_bar.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/currency_formatter.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({Key? key, required this.productId}) : super(key: key);
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(productProvider(productId));
    return Scaffold(
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: FormFactor.desktop,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p16),
              child: AsyncValueWidget<Product>(
                value: productValue,
                data: (product) => ProductScreenContents(product: product),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductScreenContents extends ConsumerWidget {
  const ProductScreenContents({Key? key, required this.product})
      : super(key: key);
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
          child: Image.network(product.imageUrl),
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
              const SizedBox(height: Sizes.p8),
              Text(product.description),
              const SizedBox(height: Sizes.p8),
              const Divider(),
              const SizedBox(height: Sizes.p8),
              Text(priceFormatted,
                  style: Theme.of(context).textTheme.headline5),
              const SizedBox(height: Sizes.p8),
              // TODO: Ratings
              // const Placeholder(fallbackHeight: 48.0),
              // const SizedBox(height: Sizes.p8),
              const Divider(),
              const SizedBox(height: Sizes.p8),
              AddToCartWidget(product: product),
            ],
          ),
        ),
      ),
    );
  }
}
