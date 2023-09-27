import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/scrollable_page.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/purchase/payment/card_payment_page.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';

class PaymentPage extends ConsumerWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = Cart.total(items);
    return ScrollablePage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TODO: Order summary
          Text(
            'Order total: \$$total',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sizes.p24),
          const Divider(),
          // TODO: Summary of items?
          const SizedBox(height: Sizes.p24),
          PrimaryButton(
            text: 'Pay by card',
            onPressed: () =>
                Navigator.of(context).push(CardPaymentPage.route()),
          ),
          const SizedBox(height: Sizes.p24),
          PrimaryButton(
            text: 'Apple Pay',
            onPressed: () => print('Implement ME!'),
          ),
          const SizedBox(height: Sizes.p24),
          PrimaryButton(
            text: 'Google Pay',
            onPressed: () => print('Implement ME!'),
          ),
        ],
      ),
    );
  }
}
