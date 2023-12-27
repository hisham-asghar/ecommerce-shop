import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_shop_ecommerce_flutter/src/services/checkout_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

class CardPaymentScreenController extends StateNotifier<VoidAsyncValue> {
  CardPaymentScreenController({required this.checkoutService})
      : super(const AsyncValue.data(null));
  final CheckoutService checkoutService;

  Future<bool> pay(bool saveCard) async {
    try {
      state = const AsyncValue.loading();
      await checkoutService.payByCard(saveCard);
      return true;
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
      // TODO: Log error
      print(e.toString());
      state = AsyncValue.error(e.message as String);
    } catch (e) {
      // fallback
      state = const AsyncValue.error('Could not place order');
    } finally {
      state = const AsyncValue.data(null);
    }
    return false;
  }
}

final cardPaymentScreenControllerProvider =
    StateNotifierProvider<CardPaymentScreenController, VoidAsyncValue>((ref) {
  final checkoutService = ref.watch(checkoutServiceProvider);
  return CardPaymentScreenController(checkoutService: checkoutService);
});
