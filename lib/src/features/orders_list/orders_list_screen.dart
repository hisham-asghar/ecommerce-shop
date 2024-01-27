import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_card.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/user_orders_service.dart';

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
            : Center(
                child: SizedBox(
                  width: FormFactor.desktop,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) => Padding(
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
              ),
      ),
    );
  }
}
