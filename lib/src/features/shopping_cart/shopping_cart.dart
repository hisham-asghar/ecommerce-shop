import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_items_builder.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';

class ShoppingCartScreen extends ConsumerWidget {
  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsValue = ref.watch(cartItemsListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: AsyncValueWidget<List<Item>>(
        value: itemsValue,
        data: (items) => ShoppingCartItemsBuilder(
          items: items,
          itemBuilder: (_, item, index) => ShoppingCartItem(
            item: item,
            itemIndex: index,
          ),
          ctaBuilder: (_) => PrimaryButton(
            text: 'Checkout',
            onPressed: () => context.goNamed(AppRoute.checkout.name),
          ),
        ),
      ),
    );
  }
}
