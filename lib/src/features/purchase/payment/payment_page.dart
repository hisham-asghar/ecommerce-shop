import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/purchase/payment/order_confirmation_details.dart';
import 'package:my_shop_ecommerce_flutter/src/features/purchase/payment/order_payment_options.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';

class PaymentPage extends ConsumerWidget {
  const PaymentPage({Key? key, this.order, this.onOrderCompleted})
      : super(key: key);
  final Order? order;
  final void Function(Order order)? onOrderCompleted;

  bool get didCompleteOrder => order != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Show items list or order list
    final itemsList =
        order != null ? order!.itemsList : ref.watch(cartProvider);
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
                  isEditable: !didCompleteOrder,
                );
              },
              childCount: itemsList.items.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: didCompleteOrder
              ? OrderConfirmationDetails(order: order!)
              : OrderPaymentOptions(
                  total: itemsList.total(),
                  onOrderCompleted: onOrderCompleted,
                ),
        ),
      ],
    );
  }
}
