import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/currency_formatter.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({Key? key, required this.product, this.onPressed})
      : super(key: key);
  final Product product;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceFormatted =
        ref.watch(currencyFormatterProvider).format(product.price);
    return Card(
      child: InkWell(
        // TODO: Tweak splash effect
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO: Handle CORS https://flutter.dev/docs/development/platform-integration/web-images
              Image.network(product.imageUrl),
              const SizedBox(height: Sizes.p8),
              const Divider(),
              const SizedBox(height: Sizes.p8),
              Text(product.title, style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: Sizes.p24),
              // TODO: Add reviews
              Text(priceFormatted,
                  style: Theme.of(context).textTheme.headline5),
            ],
          ),
        ),
      ),
    );
  }
}
