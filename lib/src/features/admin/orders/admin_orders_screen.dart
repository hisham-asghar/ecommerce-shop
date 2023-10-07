import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_card.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/admin_orders_repository.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminOrdersRepository = ref.watch(adminOrdersRepositoryProvider);
    final orders = adminOrdersRepository.allOrdersByDate();
    // TODO: Avoid duplicating code from OrdersListScreen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order management'),
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
                      viewMode: OrderViewMode.admin,
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
