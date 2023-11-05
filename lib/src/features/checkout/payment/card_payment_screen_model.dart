import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class CardPaymentScreenModel extends StateNotifier<WidgetBasicState> {
  CardPaymentScreenModel({required this.cartRepository})
      : super(const WidgetBasicState.notLoading());
  final CartRepository cartRepository;

  Future<Order?> placeOrder() async {
    try {
      state = const WidgetBasicState.loading();
      return await cartRepository.placeOrder();
    } catch (e) {
      state = const WidgetBasicState.error('Could not place order');
      return null;
    } finally {
      state = const WidgetBasicState.notLoading();
    }
  }
}

final cardPaymentScreenModelProvider =
    StateNotifierProvider<CardPaymentScreenModel, WidgetBasicState>((ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  return CardPaymentScreenModel(cartRepository: cartRepository);
});
