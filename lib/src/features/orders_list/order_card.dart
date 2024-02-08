import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_item_list_tile.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_status_drop_down/order_status_drop_down.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_status_label.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/currency_formatter.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/date_formatter.dart';

enum OrderViewMode { user, admin }

/// Shows all the details for a given order
class OrderCard extends StatelessWidget {
  const OrderCard({Key? key, required this.order, required this.viewMode})
      : super(key: key);
  final Order order;
  final OrderViewMode viewMode;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Colors.grey[400]!),
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p8)),
      ),
      child: Column(
        children: [
          OrderHeader(order: order, viewMode: viewMode),
          const Divider(height: 1, color: Colors.grey),
          OrderItemsList(order: order, viewMode: viewMode),
        ],
      ),
    );
  }
}

/// Order header showing the following:
/// - Total order amount
/// - Order date
class OrderHeader extends ConsumerWidget {
  const OrderHeader({Key? key, required this.order, required this.viewMode})
      : super(key: key);
  final Order order;
  final OrderViewMode viewMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalFormatted =
        ref.watch(currencyFormatterProvider).format(order.total);
    final dateFormatted =
        ref.watch(dateFormatterProvider).format(order.orderDate);
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(Sizes.p16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.loc.orderPlaced.toUpperCase(),
                    style: Theme.of(context).textTheme.caption,
                  ),
                  gapH4,
                  Text(dateFormatted),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    context.loc.total.toUpperCase(),
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  gapH4,
                  Text(totalFormatted),
                ],
              ),
            ],
          ),
          if (viewMode == OrderViewMode.admin)
            OrderHeaderAdminFields(order: order),
        ],
      ),
    );
  }
}

/// Shows additional order fields to be shown only in admin mode
class OrderHeaderAdminFields extends StatelessWidget {
  const OrderHeaderAdminFields({Key? key, required this.order})
      : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.p16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.loc.userId.toUpperCase(),
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.caption,
                ),
                gapH4,
                Text(order.userId),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  context.loc.userEmail.toUpperCase(),
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.caption,
                ),
                gapH4,
                // TODO: Fetch and show user email
                const Text('TBD'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// List of items in the order
class OrderItemsList extends StatelessWidget {
  const OrderItemsList({Key? key, required this.order, required this.viewMode})
      : super(key: key);
  final Order order;
  final OrderViewMode viewMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: viewMode == OrderViewMode.user
              ? OrderStatusLabel(order: order)
              : OrderStatusDropDown(
                  key: ValueKey('drop-down-${order.id}'),
                  order: order,
                ),
        ),
        for (var entry in order.items.entries)
          OrderItemListTile(
            item: Item(productId: entry.key, quantity: entry.value),
          ),
      ],
    );
  }
}
