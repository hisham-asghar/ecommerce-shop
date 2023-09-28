import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/currency_formatter.dart';

class OrderConfirmationDetails extends ConsumerWidget {
  const OrderConfirmationDetails({Key? key, required this.order})
      : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalFormatted =
        ref.watch(currentyFormatterProvider).format(order.itemsList.total());
    return Text(
      'Order total: $totalFormatted',
      style: Theme.of(context).textTheme.headline5,
      textAlign: TextAlign.center,
    );
  }
}
