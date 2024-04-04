import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/application/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/presentation/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/presentation/shopping_cart/shopping_cart_items_builder.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/presentation/payment_page/payment_button.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';

/// Payment screen showing the items in the cart (with read-only quantities) and
/// a button to checkout.
class PaymentPage extends ConsumerWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(cartTotalProvider, (_, double cartTotal) {
      // If cart value becomes 0, it means that the order has been fullfilled
      // because all the items have been removed from the cart.
      // So we should go to the orders page.
      if (cartTotal == 0) {
        context.goNamed(AppRoute.orders.name);
      }
    });
    final cartValue = ref.watch(cartProvider);
    return AsyncValueWidget<Cart>(
      value: cartValue,
      data: (cart) {
        final items = cart.toItemsList();
        return ShoppingCartItemsBuilder(
          items: items,
          itemBuilder: (_, item, index) => ShoppingCartItem(
            item: item,
            itemIndex: index,
            isEditable: false,
          ),
          ctaBuilder: (_) => const PaymentButton(),
        );
      },
    );
  }
}
