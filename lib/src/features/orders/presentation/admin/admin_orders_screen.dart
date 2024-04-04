import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_center.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/presentation/orders_list/order_card.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/domain/order.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/application/admin_orders_service.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrdersByDateValue = ref.watch(allOrdersByDateProvider);
    // TODO: Avoid duplicating code from OrdersListScreen
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.manageOrders),
      ),
      body: AsyncValueWidget<List<Order>>(
        value: allOrdersByDateValue,
        data: (orders) => CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => ResponsiveCenter(
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
    );
  }
}
