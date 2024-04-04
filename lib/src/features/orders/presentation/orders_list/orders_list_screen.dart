import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_center.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/presentation/orders_list/order_card.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/domain/order.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/application/user_orders_service.dart';

/// Shows the list of orders placed by the signed-in user.
class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersByDateValue = ref.watch(ordersByDateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.yourOrders),
      ),
      body: AsyncValueWidget<List<Order>>(
        value: ordersByDateValue,
        data: (orders) => orders.isEmpty
            ? Center(
                child: Text(
                  context.loc.noPreviousOrders,
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
              )
            : CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) => ResponsiveCenter(
                        padding: const EdgeInsets.all(Sizes.p8),
                        child: OrderCard(
                          order: orders[index],
                          viewMode: OrderViewMode.user,
                        ),
                      ),
                      childCount: orders.length,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
