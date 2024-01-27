import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_provider.dart';
import 'package:my_shop_ecommerce_flutter/src/services/checkout_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentButtonController extends StateNotifier<VoidAsyncValue> {
  PaymentButtonController(
      {required this.localizations, required this.checkoutService})
      : super(const AsyncValue.data(null));
  final AppLocalizations localizations;
  final CheckoutService checkoutService;

  Future<void> pay() async {
    var success = false;
    try {
      state = const AsyncValue.loading();
      await checkoutService.payWithPaymentSheet();
      success = true;
    } on StripeException catch (e) {
      // TODO: Use Stripe-agnostic failure type
      if (e.error.code == FailureCode.Failed) {
        if (mounted) {
          state = AsyncValue.error(
              e.error.localizedMessage ?? localizations.couldNotPlaceOrder);
        }
      } else if (e.error.code == FailureCode.Canceled) {
        // no op
      }
    } on FirebaseFunctionsException catch (e) {
      // TODO: Use Firebase-agnostic failure type
      if (mounted) {
        state = AsyncValue.error(e.message ?? localizations.couldNotPlaceOrder);
      }
    } on AssertionError catch (e) {
      if (mounted) {
        state = AsyncValue.error(e.message as String);
      }
    } catch (e) {
      // fallback
      if (mounted) {
        state = AsyncValue.error(localizations.couldNotPlaceOrder);
      }
    } finally {
      if (success) {
        // no op if the payment has been successful,
        // since order fullfillment is still in progress.
      } else {
        // note: since the provider below uses autoDispose, we need to check
        // if dispose was called (via mounted) before setting the state
        if (mounted) {
          state = const AsyncValue.data(null);
        }
      }
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
