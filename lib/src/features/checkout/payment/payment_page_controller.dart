import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/services/checkout_service.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class PaymentPageController extends StateNotifier<WidgetBasicState> {
  PaymentPageController({required this.checkoutService})
      : super(const WidgetBasicState.notLoading());
  final CheckoutService checkoutService;

  Future<void> pay() async {
    try {
      state = const WidgetBasicState.loading();
      await checkoutService.pay();
      state = const WidgetBasicState.notLoading();
    } catch (e) {
      state = const WidgetBasicState.error('Could not place order');
    } finally {
      state = const WidgetBasicState.notLoading();
    }
  }
}

final paymentPageControllerProvider =
    StateNotifierProvider<PaymentPageController, WidgetBasicState>((ref) {
  final checkoutService = ref.watch(checkoutServiceProvider);
  return PaymentPageController(checkoutService: checkoutService);
});
