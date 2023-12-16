import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/services/checkout_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

class PaymentButtonController extends StateNotifier<VoidAsyncValue> {
  PaymentButtonController({required this.checkoutService})
      : super(const AsyncValue.data(null));
  final CheckoutService checkoutService;

  Future<void> pay() async {
    try {
      state = const AsyncValue.loading();
      await checkoutService.pay();
    } catch (e) {
      state = const AsyncValue.error('Could not place order');
    } finally {
      state = const AsyncValue.data(null);
    }
  }
}

final paymentButtonControllerProvider =
    StateNotifierProvider<PaymentButtonController, VoidAsyncValue>((ref) {
  final checkoutService = ref.watch(checkoutServiceProvider);
  return PaymentButtonController(checkoutService: checkoutService);
});
