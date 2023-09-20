import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/product_list/product_data.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.data, this.onPressed})
      : super(key: key);
  final ProductData data;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(data.imageUrl),
              const SizedBox(height: 8.0),
              Text(data.title),
              const SizedBox(height: 8.0),
              // TODO: Add reviews
              // TODO: Format with intl
              Text(data.price.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
