import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart_total.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/routing.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/currency_formatter.dart';

class OrderPaymentOptions extends ConsumerWidget {
  const OrderPaymentOptions({Key? key}) : super(key: key);
  // TODO: Show order details (id, status etc)

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartTotalValue = ref.watch(cartTotalProvider);
    return AsyncValueWidget<CartTotal>(
      value: cartTotalValue,
      data: (cartTotal) {
        final totalFormatted =
            ref.watch(currencyFormatterProvider).format(cartTotal.total);
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
                onPressed: () => ref.read(routerDelegateProvider).openPay(),
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
      },
    );
  }
}
