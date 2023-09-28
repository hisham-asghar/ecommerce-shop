import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/purchase/payment/order_payment_options.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  // Order returned when the payment is complete
  Order? _order;

  Future<void> _handleOrderCompleted(Order order) async {
    setState(() => _order = order);
  }

  @override
  Widget build(BuildContext context) {
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
                // TODO: Should these be editable?
                return ShoppingCartItem(
                  item: item,
                  isEditable: _order == null,
                );
              },
              childCount: items.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          // TODO: Show order confirmation if order is complete
          child: OrderPaymentOptions(
            total: total,
            onOrderCompleted: _handleOrderCompleted,
          ),
        ),
      ],
    );
  }
}
