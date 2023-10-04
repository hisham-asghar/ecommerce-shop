import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_card.dart';
import 'package:my_shop_ecommerce_flutter/src/services/orders_manager.dart';

class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersManager = ref.watch(ordersProvider);
    final orders = ordersManager.ordersByDate;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          // TODO: Some summary of orders here?
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.all(Sizes.p8),
                child: OrderCard(
                  order: orders[index],
                ),
              ),
              childCount: orders.length,
            ),
          ),
        ],
      ),
    );
  }
}
