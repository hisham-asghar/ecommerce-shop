import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/item_quantity_selector.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_state.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/item.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class AddToCartWidget extends ConsumerWidget {
  const AddToCartWidget({Key? key, required this.product}) : super(key: key);
  final Product product;

  // TODO: move this logic to view model?
  // How to test it?
  int getAvailableQuantity(List<Item> items) {
    final alreadyInCartItems =
        items.where((element) => element.productId == product.id);
    final alreadyInCartQuantity =
        alreadyInCartItems.isNotEmpty ? alreadyInCartItems.first.quantity : 0;
    return product.availableQuantity - alreadyInCartQuantity;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AddToCartState>(addToCartControllerProvider, (_, state) {
      state.widgetState.whenOrNull(
        error: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        },
      );
    });
    final state = ref.watch(addToCartControllerProvider);
    final itemsListValue = ref.watch(cartItemsListProvider);
    return AsyncValueWidget<List<Item>>(
      value: itemsListValue,
      data: (items) {
        final availableQuantity = getAvailableQuantity(items);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quantity:'),
                ItemQuantitySelector(
                  quantity: state.quantity,
                  maxQuantity: min(availableQuantity, 10),
                  onChanged: state.widgetState.isLoading
                      ? null
                      : (quantity) {
                          final model =
                              ref.read(addToCartControllerProvider.notifier);
                          model.updateQuantity(quantity);
                        },
                ),
              ],
            ),
            const SizedBox(height: Sizes.p8),
            const Divider(),
            const SizedBox(height: Sizes.p8),
            PrimaryButton(
              isLoading: state.widgetState.isLoading,
              onPressed: availableQuantity > 0
                  ? () => ref
                      .read(addToCartControllerProvider.notifier)
                      .addItem(product)
                  : null,
              text: availableQuantity > 0 ? 'Add to Cart' : 'Out of Stock',
            ),
            if (product.availableQuantity > 0 && availableQuantity == 0) ...[
              const SizedBox(height: Sizes.p8),
              Text(
                'Already added to cart',
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              ),
            ]
          ],
        );
      },
    );
  }
}
