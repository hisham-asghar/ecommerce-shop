import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_provider.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/application/checkout_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardPaymentScreenController extends StateNotifier<VoidAsyncValue> {
  CardPaymentScreenController(
      {required this.localizations, required this.checkoutService})
      : super(const VoidAsyncValue.data(null));
  final AppLocalizations localizations;
  final CheckoutService checkoutService;

  Future<bool> pay(bool saveCard) async {
    state = const VoidAsyncValue.loading();
    final result = await checkoutService.payByCard(saveCard);
    if (mounted) {
      return result.when(
        (error) {
          error.maybeWhen(
            paymentFailed: (message) => state = VoidAsyncValue.error(
                message ?? localizations.couldNotPlaceOrder),
            // no op
            paymentCanceled: (message) =>
                state = const VoidAsyncValue.data(null),
            functions: (message) => state = VoidAsyncValue.error(message),
            orElse: () =>
                state = VoidAsyncValue.error(localizations.anErrorOccurred),
          );
          return false;
        },
        (success) {
          state = const VoidAsyncValue.data(null);
          return true;
        },
      );
    } else {
      return false;
    }
  }
}

final cardPaymentScreenControllerProvider =
    StateNotifierProvider<CardPaymentScreenController, VoidAsyncValue>((ref) {
  final localizations = ref.watch(appLocalizationsProvider);
  final checkoutService = ref.watch(checkoutServiceProvider);
  return CardPaymentScreenController(
    localizations: localizations,
    checkoutService: checkoutService,
  );
});
