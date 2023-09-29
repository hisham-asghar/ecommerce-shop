import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/item_quantity_selector.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/currency_formatter.dart';

class ShoppingCartItem extends ConsumerWidget {
  const ShoppingCartItem({Key? key, required this.item, this.isEditable = true})
      : super(key: key);
  final Item item;
  final bool isEditable;

  void _deleteItem(WidgetRef ref) {
    final cart = ref.read(cartProvider.notifier);
    cart.removeItem(item);
  }

  void _updateQuantity(WidgetRef ref, int quantity) {
    final cart = ref.read(cartProvider.notifier);
    final updated = Item(productId: item.productId, quantity: quantity);
    cart.updateItemIfExists(updated);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = findProduct(item.productId);
    final priceFormatted =
        ref.watch(currentyFormatterProvider).format(product.price);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: ResponsiveTwoColumnLayout(
          startFlex: 1,
          endFlex: 2,
          startContent: Image.network(product.imageUrl),
          spacing: Sizes.p24,
          endContent: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(product.title, style: Theme.of(context).textTheme.headline5),
              const SizedBox(height: Sizes.p24),
              Text(priceFormatted,
                  style: Theme.of(context).textTheme.headline5),
              const SizedBox(height: Sizes.p24),
              isEditable
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quantity: '),
                        const Spacer(),
                        ItemQuantitySelector(
                          quantity: item.quantity,
                          onChanged: (quantity) =>
                              _updateQuantity(ref, quantity),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red[700]),
                          onPressed: () => _deleteItem(ref),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
                      child: Text('Quantity: ${item.quantity}'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
