import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/payment_button_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

class PaymentButton extends ConsumerWidget {
  const PaymentButton({Key? key}) : super(key: key);

  Future<void> _pay(WidgetRef ref) async {
    // TODO: Only run Stripe code on supported platforms, fallback on others
    final model = ref.read(paymentButtonControllerProvider.notifier);
    await model.pay();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // error handling
    ref.listen<VoidAsyncValue>(
      paymentButtonControllerProvider,
      // TODO: Custom error handling
      (_, state) => state.showSnackBarOnError(context),
    );
    final paymentState = ref.watch(paymentButtonControllerProvider);
    return PrimaryButton(
      text: 'Pay',
      isLoading: paymentState.isLoading,
      onPressed: paymentState.isLoading ? null : () => _pay(ref),
    );
  }
}
