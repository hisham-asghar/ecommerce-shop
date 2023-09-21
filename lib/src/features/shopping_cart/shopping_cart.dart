import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';

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
    if (items.isEmpty) {
      return Center(
        child: Text(
          'Shopping Cart is empty',
          style: Theme.of(context).textTheme.headline3,
        ),
      );
    }
    final total = Cart.total(items);
    return CustomScrollView(
      slivers: [
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
        SliverPadding(
          padding: const EdgeInsets.all(Sizes.p16),
          sliver: SliverToBoxAdapter(
            child: ShoppingCartCheckout(
              total: total,
            ),
          ),
        ),
      ],
    );
  }
}

class ShoppingCartCheckout extends StatelessWidget {
  const ShoppingCartCheckout({Key? key, required this.total}) : super(key: key);
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Total: $total', style: Theme.of(context).textTheme.headline5),
        const SizedBox(height: Sizes.p24),
        PrimaryButton(
          text: 'Checkout',
          onPressed: () => print('Implement me'),
        ),
      ],
    );
  }
}
