import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/item_quantity_selector.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item_model.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/currency_formatter.dart';

class ShoppingCartItem extends ConsumerWidget {
  const ShoppingCartItem({Key? key, required this.item, this.isEditable = true})
      : super(key: key);
  final Item item;
  final bool isEditable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(productProvider(item.productId));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: AsyncValueWidget<Product>(
            value: productValue,
            data: (product) => ShoppingCartItemContents(
              product: product,
              item: item,
              isEditable: isEditable,
            ),
          ),
        ),
      ),
    );
  }
}

class ShoppingCartItemContents extends ConsumerWidget {
  const ShoppingCartItemContents(
      {Key? key,
      required this.product,
      required this.item,
      required this.isEditable})
      : super(key: key);
  final Product product;
  final Item item;
  final bool isEditable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // error handling
    ref.listen(
      shoppingCartItemModelProvider,
      (WidgetBasicState state) => widgetStateErrorListener(context, state),
    );
    final state = ref.watch(shoppingCartItemModelProvider);
    final priceFormatted =
        ref.watch(currencyFormatterProvider).format(product.price);
    return ResponsiveTwoColumnLayout(
      startFlex: 1,
      endFlex: 2,
      // TODO: Handle CORS https://flutter.dev/docs/development/platform-integration/web-images
      startContent: Image.network(product.imageUrl),
      spacing: Sizes.p24,
      endContent: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(product.title, style: Theme.of(context).textTheme.headline5),
          const SizedBox(height: Sizes.p24),
          Text(priceFormatted, style: Theme.of(context).textTheme.headline5),
          const SizedBox(height: Sizes.p24),
          isEditable
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ItemQuantitySelector(
                      quantity: item.quantity,
                      maxQuantity: min(product.availableQuantity, 10),
                      onChanged: state == const WidgetBasicState.loading()
                          ? null
                          : (quantity) => ref
                              .read(shoppingCartItemModelProvider.notifier)
                              .updateQuantity(item, quantity),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[700]),
                      onPressed: state == const WidgetBasicState.loading()
                          ? null
                          : () => ref
                              .read(shoppingCartItemModelProvider.notifier)
                              .deleteItem(item),
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
    );
  }
}
