import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Order total: $totalFormatted',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: Sizes.p16),
            Text(
              'Order ID: ${order.id}',
            ),
            const SizedBox(height: Sizes.p16),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Payment Status: ',
                    style: Theme.of(context).textTheme.bodyText2),
                TextSpan(
                    text: order.paymentStatus.status(),
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ]),
            ),
            const SizedBox(height: Sizes.p16),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Delivery Status: ',
                    style: Theme.of(context).textTheme.bodyText2),
                TextSpan(
                    text: order.deliveryStatus.status(),
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ]),
            ),
            const SizedBox(height: Sizes.p32),
          ],
        ),
      ),
    );
  }
}
