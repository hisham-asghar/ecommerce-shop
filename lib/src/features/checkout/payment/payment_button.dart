import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/payment_button_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

/// Button used to initiate the payment flow.
class PaymentButton extends ConsumerWidget {
  const PaymentButton({Key? key}) : super(key: key);

  Future<void> _pay(BuildContext context, WidgetRef ref) async {
    // TODO: How to test this?
    if (kIsWeb) {
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
      (_, state) => state.showAlertDialogOnError(context),
    );
    final paymentState = ref.watch(paymentButtonControllerProvider);
    return PrimaryButton(
      text: context.loc.pay,
      isLoading: paymentState.isLoading,
      onPressed: paymentState.isLoading ? null : () => _pay(context, ref),
    );
  }
}
