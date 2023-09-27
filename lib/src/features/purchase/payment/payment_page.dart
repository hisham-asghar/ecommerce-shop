import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/purchase/payment/card_payment_page.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';

class PaymentPage extends ConsumerWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = Cart.total(items);
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(height: Sizes.p16),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(Sizes.p16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = items[index];
                // TODO: Should these be editable??
                return ShoppingCartItem(item: item);
              },
              childCount: items.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: OrderPaymentOptions(total: total),
        ),
      ],
    );
  }
}

class OrderPaymentOptions extends StatelessWidget {
  const OrderPaymentOptions({Key? key, required this.total}) : super(key: key);
  final double total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Order total: \$$total',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sizes.p24),
          const Divider(),
          // TODO: Summary of items?
          const SizedBox(height: Sizes.p24),
          PrimaryButton(
            text: 'Pay by card',
            onPressed: () =>
                Navigator.of(context).push(CardPaymentPage.route()),
          ),
          const SizedBox(height: Sizes.p24),
          PrimaryButton(
            text: 'Apple Pay',
            onPressed: () => print('Implement ME!'),
          ),
          const SizedBox(height: Sizes.p24),
          PrimaryButton(
            text: 'Google Pay',
            onPressed: () => print('Implement ME!'),
          )
        ],
      ),
    );
  }
}
