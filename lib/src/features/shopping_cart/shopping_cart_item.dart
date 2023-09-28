import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart_box.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

class ShoppingCartItem extends ConsumerWidget {
  const ShoppingCartItem({Key? key, required this.item}) : super(key: key);
  final CartItem item;

  void _deleteItem(WidgetRef ref) {
    final cart = ref.read(cartProvider.notifier);
    cart.removeItem(item);
  }

  void _updateQuantity(WidgetRef ref, int quantity) {
    final cart = ref.read(cartProvider.notifier);
    final updated = CartItem(productId: item.productId, quantity: quantity);
    cart.updateItemIfExists(updated);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = findProduct(item.productId);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: ResponsiveTwoColumnLayout(
          startContent: Image.network(product.imageUrl),
          spacing: Sizes.p24,
          endContent: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(product.title, style: Theme.of(context).textTheme.headline5),
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
                  const Spacer(),
                  ItemQuantityDropdown(
                    value: item.quantity,
                    onChanged: (quantity) => _updateQuantity(ref, quantity!),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[700]),
                    onPressed: () => _deleteItem(ref),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
