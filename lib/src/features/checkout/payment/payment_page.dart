import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/order_payment_options.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';

class PaymentPage extends ConsumerWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsList = ref.watch(cartProvider);
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
                final item = itemsList.items[index];
                return ShoppingCartItem(
                  item: item,
                  // make item non editable so that user can't empty cart completely
                  isEditable: false,
                );
              },
              childCount: itemsList.items.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: OrderPaymentOptions(total: itemsList.total()),
        ),
      ],
    );
  }
}
