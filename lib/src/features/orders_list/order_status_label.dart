import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/date_formatter.dart';

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
