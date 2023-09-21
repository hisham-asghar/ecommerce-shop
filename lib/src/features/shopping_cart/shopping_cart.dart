import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart_item.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => ShoppingCartPage(),
      fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ShoppingCartContents(),
    );
  }
}

class ShoppingCartContents extends ConsumerWidget {
  const ShoppingCartContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);

    // TODO: List of items
    // Each item:
    // - image
    // - name
    // - price
    // - quantity dropdown
    // - delete button

    // Then show summary with checkout button
    return CustomScrollView(
      slivers: [
        // TODO: Carousel?
        SliverPadding(
          padding: const EdgeInsets.all(Sizes.p16),
          sliver: SliverToBoxAdapter(
            child: Text('Shopping Cart',
                style: Theme.of(context).textTheme.headline4),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: Sizes.p16),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(Sizes.p16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = items[index];
                return ShoppingCartItem(item: item);
              },
              childCount: items.length,
            ),
          ),
        ),
        // TODO: Checkout section
      ],
    );
  }
}
