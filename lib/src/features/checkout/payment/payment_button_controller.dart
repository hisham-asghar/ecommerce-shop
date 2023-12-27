import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_shop_ecommerce_flutter/src/services/checkout_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

class PaymentButtonController extends StateNotifier<VoidAsyncValue> {
  PaymentButtonController({required this.checkoutService})
      : super(const AsyncValue.data(null));
  final CheckoutService checkoutService;

  Future<void> pay() async {
    try {
      state = const AsyncValue.loading();
      await checkoutService.payWithPaymentSheet();
    } on StripeException catch (e) {
      // TODO: Use Stripe-agnostic failure type
      if (e.error.code == FailureCode.Failed) {
        state = AsyncValue.error(
            e.error.localizedMessage ?? 'Could not place order');
      } else if (e.error.code == FailureCode.Canceled) {
        // no op
      }
    } on FirebaseFunctionsException catch (e) {
      // TODO: Use Firebase-agnostic failure type
      state = AsyncValue.error(e.message ?? 'Could not place order');
    } on AssertionError catch (e) {
      state = AsyncValue.error(e.message as String);
    } catch (e) {
      // fallback
      state = const AsyncValue.error('Could not place order');
    } finally {
      // TODO: this should be no op if the payment has been successful,
      // since order fullfillment is still in progress.
      // However, leaving the state as AsyncValue.loading() will cause
      // the button to be in loading state the next time we open the payment page.
      const AsyncValue.data(null);
    }
  }
}

final paymentButtonControllerProvider =
    StateNotifierProvider<PaymentButtonController, VoidAsyncValue>((ref) {
  final checkoutService = ref.watch(checkoutServiceProvider);
  return PaymentButtonController(checkoutService: checkoutService);
});
