import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_state.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

class AddToCartController extends StateNotifier<AddToCartState> {
  AddToCartController({required this.cartService, required this.product})
      : super(AddToCartState(
          quantity: 1,
          widgetState: const VoidAsyncValue.data(null),
        ));
  final CartService cartService;
  final Product product;

  // calculates the available quantity of the product
  // given how many items are already in the cart
  int getAvailableQuantity(List<Item> cartItems) {
    final alreadyInCartItems =
        cartItems.where((item) => item.productId == product.id);
    final alreadyInCartQuantity =
        alreadyInCartItems.isNotEmpty ? alreadyInCartItems.first.quantity : 0;
    return max(0, product.availableQuantity - alreadyInCartQuantity);
  }

  void updateQuantity(int quantity) {
    state = state.copyWith(quantity: quantity);
  }

  Future<void> addItem() async {
    try {
      state = state.copyWith(widgetState: const VoidAsyncValue.loading());
      final item = Item(
        productId: product.id,
        quantity: state.quantity,
      );
      await cartService.addItem(item);
      state = state.copyWith(
        quantity: 1,
        widgetState: const VoidAsyncValue.data(null),
      );
    } catch (e) {
      // first, emit an error
      state = state.copyWith(
        widgetState: const VoidAsyncValue.error('Can\'t add item to cart'),
      );
      // then, emit notLoading
      state = state.copyWith(
        widgetState: const VoidAsyncValue.data(null),
      );
    }
  }
}

final addToCartControllerProvider =
    StateNotifierProvider.family<AddToCartController, AddToCartState, Product>(
        (ref, product) {
  final cartRepository = ref.watch(cartServiceProvider);
  return AddToCartController(cartService: cartRepository, product: product);
});
