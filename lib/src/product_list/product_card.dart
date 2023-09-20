import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';

class ProductCardData {
  ProductCardData(
      {required this.imageUrl, required this.title, required this.price});
  final String imageUrl;
  final String title;
  final double price;
  // TODO: Add reviews

}

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.data}) : super(key: key);
  final ProductCardData data;
  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
