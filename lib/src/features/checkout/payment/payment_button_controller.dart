import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_provider.dart';
import 'package:my_shop_ecommerce_flutter/src/services/checkout_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentButtonController extends StateNotifier<VoidAsyncValue> {
  PaymentButtonController(
      {required this.localizations, required this.checkoutService})
      : super(const VoidAsyncValue.data(null));
  final AppLocalizations localizations;
  final CheckoutService checkoutService;

  Future<void> pay() async {
    state = const VoidAsyncValue.loading();
    final result = await checkoutService.payWithPaymentSheet();
    if (mounted) {
      return result.when((error) {
        error.maybeWhen(
          paymentFailed: (message) => state =
              VoidAsyncValue.error(message ?? localizations.couldNotPlaceOrder),
          // no op
          paymentCanceled: (message) => state = const VoidAsyncValue.data(null),
          functions: (message) => state = VoidAsyncValue.error(message),
          orElse: () =>
              state = VoidAsyncValue.error(localizations.anErrorOccurred),
        );
      }, (success) {
        state = const VoidAsyncValue.data(null);
      });
    }
  }
}

final paymentButtonControllerProvider =
    StateNotifierProvider.autoDispose<PaymentButtonController, VoidAsyncValue>(
        (ref) {
  final localizations = ref.watch(appLocalizationsProvider);
  final checkoutService = ref.watch(checkoutServiceProvider);
  return PaymentButtonController(
    localizations: localizations,
    checkoutService: checkoutService,
  );
});
