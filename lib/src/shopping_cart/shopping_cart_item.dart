import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/product_page/add_to_cart_box.dart';

class ShoppingCartItem extends StatelessWidget {
  const ShoppingCartItem({Key? key, required this.item}) : super(key: key);
  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final product = findProduct(item.productId);
    // TODO: Row on large layouts, column on mobile
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl),
            const SizedBox(height: 8.0),
            Text(product.title),
            const SizedBox(height: 8.0),
            // TODO: Format with intl
            Text(product.price.toString()),
            const SizedBox(height: 8.0),
            ItemQuantityDropdown(
              value: item.quantity,
              onChanged: (_) => print('implement me'),
            ),
          ],
        ),
      ),
    );
  }
}
