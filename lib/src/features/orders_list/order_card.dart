import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/currency_formatter.dart';
import 'package:my_shop_ecommerce_flutter/src/services/date_formatter.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({Key? key, required this.order}) : super(key: key);
  final Order order;

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
          OrderHeader(order: order),
          const Divider(height: 1, color: Colors.grey),
          //const SizedBox(height: Sizes.p16),
          OrderItemsList(order: order),
        ],
      ),
    );
  }
}

class OrderHeader extends ConsumerWidget {
  const OrderHeader({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalFormatted =
        ref.watch(currentyFormatterProvider).format(order.itemsList.total());
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
            ],
          )
        ],
      ),
      // TODO: Show order ID on desktop?
    );
  }
}

class OrderItemsList extends ConsumerWidget {
  const OrderItemsList({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: OrderStatusLabel(order: order),
        ),
        for (var item in order.itemsList.items) OrderItemListTile(item: item),
      ],
    );
  }
}

class OrderStatusLabel extends ConsumerWidget {
  const OrderStatusLabel({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme.bodyText1!;
    switch (order.orderStatus) {
      case OrderStatus.confirmed:
        return Text('Confirmed - preparing for delivery', style: textStyle);
      case OrderStatus.shipped:
        if (order.deliveryDate != null) {
          final date =
              ref.watch(dateFormatterProvider).format(order.deliveryDate!);
          return Text('Shipped - estimated delivery $date', style: textStyle);
        } else {
          return Text('Shipped', style: textStyle);
        }
      case OrderStatus.delivered:
        if (order.deliveryDate != null) {
          final date =
              ref.watch(dateFormatterProvider).format(order.deliveryDate!);
          return Text('Delivered $date',
              style: textStyle.copyWith(color: Colors.green));
        } else {
          return Text('Delivered',
              style: textStyle.copyWith(color: Colors.green));
        }
      default:
        return Container();
    }
  }
}

class OrderItemListTile extends StatelessWidget {
  const OrderItemListTile({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    final product = findProduct(item.productId);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Image.network(product.imageUrl),
          ),
          const SizedBox(width: Sizes.p8),
          Flexible(
            flex: 3,
            child: Text(product.title),
          ),
        ],
      ),
    );
  }
}
