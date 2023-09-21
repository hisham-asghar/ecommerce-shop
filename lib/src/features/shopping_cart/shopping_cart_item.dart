import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/secondary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart_box.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Image.network(product.imageUrl),
            ),
            SizedBox(width: Sizes.p24),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(product.title,
                      style: Theme.of(context).textTheme.headline5),
                  SizedBox(height: Sizes.p24),
                  Text('Price: ${product.price}',
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(height: Sizes.p24),
                  Text(product.description),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quantity: '),
                      ItemQuantityDropdown(
                        value: item.quantity,
                        // TODO: Implement
                        onChanged: (_) => print('implement me'),
                      ),
                    ],
                  ),
                  // TODO: Delete
                  SecondaryButton(
                    // TODO: Implement
                    onPressed: () => print('implement me'),
                    text: 'Delete',
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Image.network(product.imageUrl),
        //     const SizedBox(height: 8.0),
        //     Text(product.title),
        //     const SizedBox(height: 8.0),
        //     // TODO: Format with intl
        //     Text(product.price.toString()),
        // const SizedBox(height: 8.0),
        // ItemQuantityDropdown(
        //   value: item.quantity,
        //   onChanged: (_) => print('implement me'),
        // ),
        //   ],
        // ),
      ),
    );
  }
}
