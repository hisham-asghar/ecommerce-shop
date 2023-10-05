import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/item_quantity_selector.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/services/currency_formatter.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class ShoppingCartItem extends ConsumerWidget {
  const ShoppingCartItem({Key? key, required this.item, this.isEditable = true})
      : super(key: key);
  final Item item;
  final bool isEditable;

  void _deleteItem(WidgetRef ref) {
    final cart = ref.read(cartProvider.notifier);
    cart.removeItem(item);
    final itemsList = ref.read(cartProvider);
    if (itemsList.items.isEmpty) {
      // TODO: navigate back?
    }
  }

  void _updateQuantity(WidgetRef ref, int quantity) {
    final cart = ref.read(cartProvider.notifier);
    final updated = Item(productId: item.productId, quantity: quantity);
    cart.updateItemIfExists(updated);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataStore = ref.watch(dataStoreProvider);
    final product = dataStore.findProduct(item.productId);
    final priceFormatted =
        ref.watch(currentyFormatterProvider).format(product.price);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: ResponsiveTwoColumnLayout(
            startFlex: 1,
            endFlex: 2,
            // TODO: Handle CORS https://flutter.dev/docs/development/platform-integration/web-images
            startContent: Image.network(product.imageUrl),
            spacing: Sizes.p24,
            endContent: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(product.title,
                    style: Theme.of(context).textTheme.headline5),
                const SizedBox(height: Sizes.p24),
                Text(priceFormatted,
                    style: Theme.of(context).textTheme.headline5),
                const SizedBox(height: Sizes.p24),
                isEditable
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemQuantitySelector(
                            quantity: item.quantity,
                            onChanged: (quantity) =>
                                _updateQuantity(ref, quantity),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red[700]),
                            onPressed: () => _deleteItem(ref),
                          ),
                          const Spacer(),
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
      ),
    );
  }
}
