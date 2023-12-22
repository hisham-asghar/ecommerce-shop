import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/payment_button_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/platform/platform_is.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

class PaymentButton extends ConsumerWidget {
  const PaymentButton({Key? key}) : super(key: key);

  Future<void> _pay(BuildContext context, WidgetRef ref) async {
    if (PlatformIs.web) {
      context.goNamed(AppRoute.cardPayment.name);
    } else {
      final controller = ref.read(paymentButtonControllerProvider.notifier);
      await controller.pay();
    }
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
      onPressed: paymentState.isLoading ? null : () => _pay(context, ref),
    );
  }
}
