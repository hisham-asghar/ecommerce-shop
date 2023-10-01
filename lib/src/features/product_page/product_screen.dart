import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/home_app_bar.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/currency_formatter.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceFormatted =
        ref.watch(currentyFormatterProvider).format(product.price);
    return Scaffold(
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: FormFactor.desktop,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p16),
              child: ResponsiveTwoColumnLayout(
                startContent: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p16),
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
                        Text(product.title,
                            style: Theme.of(context).textTheme.headline6),
                        const SizedBox(height: Sizes.p8),
                        Text(product.description),
                        const SizedBox(height: Sizes.p8),
                        const Divider(),
                        const SizedBox(height: Sizes.p8),
                        Text(priceFormatted,
                            style: Theme.of(context).textTheme.headline5),
                        const SizedBox(height: Sizes.p8),
                        // TODO: Ratings
                        const Placeholder(fallbackHeight: 48.0),
                        const SizedBox(height: Sizes.p8),
                        const Divider(),
                        const SizedBox(height: Sizes.p8),
                        AddToCartWidget(product: product),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
