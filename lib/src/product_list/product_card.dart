import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product, this.onPressed})
      : super(key: key);
  final Product product;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        // TODO: Tweak splash effect
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(product.imageUrl),
              const SizedBox(height: 8.0),
              Text(product.title),
              const SizedBox(height: 8.0),
              // TODO: Add reviews
              // TODO: Format with intl
              Text(product.price.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
