import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_state.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class AddToCartController extends StateNotifier<AddToCartState> {
  AddToCartController({required this.cartService})
      : super(AddToCartState(
          quantity: 1,
          widgetState: const WidgetBasicState.notLoading(),
        ));
  final CartService cartService;

  void updateQuantity(int quantity) {
    state = state.copyWith(quantity: quantity);
  }

  Future<void> addItem(Product product) async {
    try {
      state = state.copyWith(widgetState: const WidgetBasicState.loading());
      final item = Item(
        productId: product.id,
        quantity: state.quantity,
      );
      await cartService.addItem(item);
      state = state.copyWith(
        quantity: 1,
        widgetState: const WidgetBasicState.notLoading(),
      );
    } catch (e) {
      // first, emit an error
      state = state.copyWith(
        widgetState: const WidgetBasicState.error('Can\'t add item to cart'),
      );
      // then, emit notLoading
      state = state.copyWith(
        widgetState: const WidgetBasicState.notLoading(),
      );
    }
  }
}

final addToCartControllerProvider =
    StateNotifierProvider<AddToCartController, AddToCartState>((ref) {
  final cartRepository = ref.watch(cartServiceProvider);
  return AddToCartController(cartService: cartRepository);
});
