import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/payment_page_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/platform/platform_is.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_total.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/currency_formatter.dart';

class PaymentPagePay extends ConsumerWidget {
  const PaymentPagePay({Key? key}) : super(key: key);

  Future<void> _pay(WidgetRef ref) async {
    if (PlatformIs.android || PlatformIs.iOS) {
      final model = ref.read(paymentPageControllerProvider.notifier);
      await model.pay();
      // note: back navigation happens once the order is fullfilled (webhook logic)
    } else {
      // TODO: show alert dialog and fallthrough
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // error handling
    ref.listen<WidgetBasicState>(
      paymentPageControllerProvider,
      // TODO: Custom error handling
      (_, state) => widgetStateErrorListener(context, state),
    );
    final cartTotalValue = ref.watch(cartTotalProvider);
    final paymentState = ref.watch(paymentPageControllerProvider);
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
              PrimaryButton(
                text: 'Pay',
                isLoading: paymentState.isLoading,
                onPressed: paymentState.isLoading ? null : () => _pay(ref),
              ),
            ],
          ),
        );
      },
    );
  }
}
