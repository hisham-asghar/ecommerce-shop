import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';

class OrderStatusLabel extends ConsumerWidget {
  const OrderStatusLabel({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme.bodyText1!;
    switch (order.orderStatus) {
      case OrderStatus.confirmed:
        return Text(
          context.loc.confirmedPreparingDelivery,
          style: textStyle,
        );
      case OrderStatus.shipped:
        return Text(
          context.loc.shipped,
          style: textStyle,
        );
      case OrderStatus.delivered:
        return Text(
          context.loc.delivered,
          style: textStyle.copyWith(color: Colors.green),
        );
    }
  }
}
