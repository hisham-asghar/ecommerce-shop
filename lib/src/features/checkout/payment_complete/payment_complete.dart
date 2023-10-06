import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/order_confirmation_details.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';

class PaymentCompleteScreen extends StatelessWidget {
  const PaymentCompleteScreen({Key? key, required this.order})
      : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    // Show items list or order list
    final items = order.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Complete'),
      ),
      body: CustomScrollView(
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
                  return ShoppingCartItem(
                    item: item,
                    isEditable: false,
                  );
                },
                childCount: items.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: OrderConfirmationDetails(order: order),
          ),
        ],
      ),
    );
  }
}
