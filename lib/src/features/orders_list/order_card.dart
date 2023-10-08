import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_item_list_tile.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_status_drop_down.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_status_label.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/currency_formatter.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/date_formatter.dart';

enum OrderViewMode { user, admin }

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
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
      ),
      child: Column(
        children: [
          OrderHeader(order: order, viewMode: viewMode),
          const Divider(height: 1, color: Colors.grey),
          //const SizedBox(height: Sizes.p16),
          OrderItemsList(order: order, viewMode: viewMode),
        ],
      ),
    );
  }
}

class OrderHeader extends ConsumerWidget {
  const OrderHeader({Key? key, required this.order, required this.viewMode})
      : super(key: key);
  final Order order;
  final OrderViewMode viewMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsRepository = ref.watch(productsRepositoryProvider);
    final totalFormatted = ref
        .watch(currencyFormatterProvider)
        .format(productsRepository.calculateTotal(order.items));
    final dateFormatted =
        ref.watch(dateFormatterProvider).format(order.orderDate);
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(Sizes.p16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order placed'.toUpperCase(),
                  style: Theme.of(context).textTheme.caption),
              const SizedBox(height: Sizes.p4),
              Text(dateFormatted),
              if (viewMode == OrderViewMode.admin) ...[
                const SizedBox(height: Sizes.p16),
                Text('User ID'.toUpperCase(),
                    style: Theme.of(context).textTheme.caption),
                const SizedBox(height: Sizes.p4),
                Text(order.userId),
              ],
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Total'.toUpperCase(),
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(height: Sizes.p4),
              Text(totalFormatted),
              if (viewMode == OrderViewMode.admin) ...[
                const SizedBox(height: Sizes.p16),
                Text('User email'.toUpperCase(),
                    style: Theme.of(context).textTheme.caption),
                const SizedBox(height: Sizes.p4),
                // TODO: Fetch and show user email
                const Text('TBD'),
              ],
            ],
          )
        ],
      ),
      // TODO: Show order ID on desktop?
    );
  }
}

class OrderItemsList extends ConsumerWidget {
  const OrderItemsList({Key? key, required this.order, required this.viewMode})
      : super(key: key);
  final Order order;
  final OrderViewMode viewMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: viewMode == OrderViewMode.user
              ? OrderStatusLabel(order: order)
              : OrderStatusDropDown(order: order),
        ),
        for (var item in order.items) OrderItemListTile(item: item),
      ],
    );
  }
}
