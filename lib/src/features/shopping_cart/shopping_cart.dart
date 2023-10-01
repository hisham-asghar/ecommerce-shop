import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/routing.dart';
import 'package:my_shop_ecommerce_flutter/src/services/currency_formatter.dart';

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: const ShoppingCartContents(),
    );
  }
}

class ShoppingCartContents extends ConsumerWidget {
  const ShoppingCartContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsList = ref.watch(cartProvider);
    if (itemsList.items.isEmpty) {
      return Center(
        child: Text(
          'Shopping Cart is empty',
          style: Theme.of(context).textTheme.headline3,
        ),
      );
    }
    final screenWidth = MediaQuery.of(context).size.width;
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
                              final item = itemsList.items[index];
                              return ShoppingCartItem(item: item);
                            },
                            childCount: itemsList.items.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Sizes.p16),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                    child: ShoppingCartCheckout(total: itemsList.total()),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(Sizes.p16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = itemsList.items[index];
                  return ShoppingCartItem(item: item);
                },
                childCount: itemsList.items.length,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(Sizes.p16),
            sliver: SliverToBoxAdapter(
              child: ShoppingCartCheckout(total: itemsList.total()),
            ),
          ),
        ],
      );
    }
  }
}

class ShoppingCartCheckout extends ConsumerWidget {
  const ShoppingCartCheckout({Key? key, required this.total}) : super(key: key);
  final double total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalFormatted = ref.watch(currentyFormatterProvider).format(total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Total: $totalFormatted',
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Sizes.p24),
        PrimaryButton(
          text: 'Checkout',
          onPressed: () => ref.read(routerDelegateProvider).openCheckout(),
        ),
      ],
    );
  }
}
