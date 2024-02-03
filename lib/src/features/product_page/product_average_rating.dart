import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';

/// Shows the product average rating score and the number of ratings
class ProductAverageRating extends StatelessWidget {
  const ProductAverageRating({Key? key, required this.product})
      : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        gapW8,
        Text(
          product.avgRating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        gapW8,
        Text(
          context.loc.numRatings(product.numRatings),
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }
}
