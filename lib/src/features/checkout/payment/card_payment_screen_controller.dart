import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class CardPaymentScreenController extends StateNotifier<WidgetBasicState> {
  CardPaymentScreenController({required this.cartService})
      : super(const WidgetBasicState.notLoading());
  final CartService cartService;

  Future<Order?> placeOrder() async {
    try {
      state = const WidgetBasicState.loading();
      return await cartService.placeOrder();
    } catch (e) {
      state = const WidgetBasicState.error('Could not place order');
      return null;
    } finally {
      state = const WidgetBasicState.notLoading();
    }
  }
}

final cardPaymentScreenControllerProvider =
    StateNotifierProvider<CardPaymentScreenController, WidgetBasicState>((ref) {
  final cartRepository = ref.watch(cartServiceProvider);
  return CardPaymentScreenController(cartService: cartRepository);
});
