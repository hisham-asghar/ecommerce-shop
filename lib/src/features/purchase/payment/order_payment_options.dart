import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/purchase/payment/card_payment_page.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/currency_formatter.dart';

class OrderPaymentOptions extends ConsumerWidget {
  const OrderPaymentOptions(
      {Key? key, required this.total, this.onOrderCompleted})
      : super(key: key);
  // TODO: Show order details (id, status etc)
  final double total;
  final void Function(Order order)? onOrderCompleted;

  Future<void> _proceedToPayment(BuildContext context) async {
    // TODO: Add tests for this
    final order = await Navigator.of(context).push(CardPaymentPage.route());
    if (order != null) {
      onOrderCompleted?.call(order);
    } else {
      print('Payment not completed');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalFormatted = ref.watch(currentyFormatterProvider).format(total);
    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Order total: $totalFormatted',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sizes.p24),
          const Divider(),
          const SizedBox(height: Sizes.p24),
          PrimaryButton(
            text: 'Pay by card',
            onPressed: () => _proceedToPayment(context),
          ),
          // const SizedBox(height: Sizes.p24),
          // PrimaryButton(
          //   text: 'Apple Pay',
          //   onPressed: () => print('Implement ME!'),
          // ),
          // const SizedBox(height: Sizes.p24),
          // PrimaryButton(
          //   text: 'Google Pay',
          //   onPressed: () => print('Implement ME!'),
          // )
        ],
      ),
    );
  }
}
