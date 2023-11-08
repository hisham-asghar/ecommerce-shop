import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/item_quantity_selector.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_model.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_state.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class AddToCartWidget extends ConsumerWidget {
  const AddToCartWidget({Key? key, required this.product}) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AddToCartState>(addToCartModelProvider, (_, state) {
      state.widgetState.whenOrNull(
        error: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        },
      );
    });
    final state = ref.watch(addToCartModelProvider);
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
              maxQuantity: min(product.availableQuantity, 10),
              onChanged: state.widgetState.isLoading
                  ? null
                  : (quantity) {
                      final model = ref.read(addToCartModelProvider.notifier);
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
          onPressed: product.availableQuantity > 0
              ? () => ref.read(addToCartModelProvider.notifier).addItem(product)
              : null,
          text: product.availableQuantity > 0 ? 'Add to Cart' : 'Out of Stock',
        ),
      ],
    );
  }
}
