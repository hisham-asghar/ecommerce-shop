import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/item_quantity_selector.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_state.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

class AddToCartWidget extends ConsumerWidget {
  const AddToCartWidget({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AddToCartState>(
      addToCartControllerProvider(product),
      (_, state) => state.widgetState.showSnackBarOnError(context),
    );
    final state = ref.watch(addToCartControllerProvider(product));
    final itemAvailableQuantity =
        ref.watch(itemAvailableQuantityProvider(product));
    return AsyncValueWidget<int>(
      value: itemAvailableQuantity,
      data: (availableQuantity) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.loc.quantity),
                ItemQuantitySelector(
                  quantity: state.quantity,
                  maxQuantity: min(availableQuantity, 10),
                  onChanged: state.widgetState.isLoading
                      ? null
                      : (quantity) => ref
                          .read(addToCartControllerProvider(product).notifier)
                          .updateQuantity(quantity),
                ),
              ],
            ),
            gapH8,
            const Divider(),
            gapH8,
            PrimaryButton(
              isLoading: state.widgetState.isLoading,
              onPressed: availableQuantity > 0
                  ? () => ref
                      .read(addToCartControllerProvider(product).notifier)
                      .addItem()
                  : null,
              text: availableQuantity > 0
                  ? context.loc.addToCart
                  : context.loc.outOfStock,
            ),
            if (product.availableQuantity > 0 && availableQuantity == 0) ...[
              gapH8,
              Text(
                context.loc.alreadyAddedToCart,
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
