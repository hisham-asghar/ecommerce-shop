import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_card.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/orders_repository.dart';

class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersRepository = ref.watch(ordersRepositoryProvider);
    final orders = ordersRepository.ordersByDate;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: Center(
        child: SizedBox(
          width: FormFactor.desktop,
          child: CustomScrollView(
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
        ),
      ),
    );
  }
}
