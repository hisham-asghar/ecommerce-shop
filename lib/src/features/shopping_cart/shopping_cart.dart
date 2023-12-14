import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/decorated_box_with_shadow.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/shopping_cart_total_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/currency_formatter.dart';

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
        data: (items) => ShoppingCartContents(items: items),
      ),
    );
  }
}

class ShoppingCartContents extends ConsumerWidget {
  const ShoppingCartContents({Key? key, required this.items}) : super(key: key);
  final List<Item> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'Shopping Cart is empty',
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
      );
    }
    final screenWidth = MediaQuery.of(context).size.width;
    // wide layouts
    if (screenWidth >= FormFactor.tablet) {
      return Center(
        child: SizedBox(
          width: FormFactor.desktop,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: Row(
              children: [
                Flexible(
                  flex: 3,
                  // TODO: Hide scrollbar
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding:
                            const EdgeInsets.symmetric(vertical: Sizes.p16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = items[index];
                              return ShoppingCartItem(
                                item: item,
                                itemIndex: index,
                              );
                            },
                            childCount: items.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Sizes.p16),
                const Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: Sizes.p16),
                    child: ShoppingCartCheckout(),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      // narrow layouts
      return Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = items[index];
                        return ShoppingCartItem(
                          item: item,
                          itemIndex: index,
                        );
                      },
                      childCount: items.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const DecoratedBoxWithShadow(
            child: ShoppingCartCheckout(),
          ),
        ],
      );
    }
  }
}

class ShoppingCartCheckout extends ConsumerWidget {
  const ShoppingCartCheckout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShoppingCartTotalWidget(
      ctaBuilder: (_) => PrimaryButton(
        text: 'Checkout',
        onPressed: () => context.pushNamed(AppRoute.checkout.name),
      ),
    );
  }
}
