import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/secondary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart_box.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

class ShoppingCartItem extends ConsumerWidget {
  const ShoppingCartItem({Key? key, required this.item}) : super(key: key);
  final CartItem item;

  void deleteItem(WidgetRef ref) {
    final cart = ref.read(cartProvider.notifier);
    cart.removeItem(item);
  }

  void updateQuantity(WidgetRef ref, int quantity) {
    final cart = ref.read(cartProvider.notifier);
    final updated = CartItem(productId: item.productId, quantity: quantity);
    cart.updateItemIfExists(updated);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            const SizedBox(width: Sizes.p24),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(product.title,
                      style: Theme.of(context).textTheme.headline5),
                  const SizedBox(height: Sizes.p24),
                  Text('Price: ${product.price}',
                      style: Theme.of(context).textTheme.subtitle1),
                  const SizedBox(height: Sizes.p24),
                  Text(product.description),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Quantity: '),
                      ItemQuantityDropdown(
                        value: item.quantity,
                        // TODO: Implement
                        onChanged: (_) => print('implement me'),
                      ),
                    ],
                  ),
                  SecondaryButton(
                    onPressed: () => deleteItem(ref),
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
