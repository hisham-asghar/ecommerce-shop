import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/order_confirmation_details.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/user_orders_service.dart';

class PaymentCompleteScreen extends ConsumerWidget {
  const PaymentCompleteScreen({Key? key, required this.orderId})
      : super(key: key);
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(userOrderProvider(orderId));
    return AsyncValueWidget<Order>(
      value: order,
      data: (order) {
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
      },
    );
  }
}
