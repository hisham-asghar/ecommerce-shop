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

// calculates the available quantity of the product
// given how many items are already in the cart
final itemAvailableQuantityProvider =
    FutureProvider.autoDispose.family<int, Product>((ref, product) async {
  // simple example of how this works:
  // https://dartpad.dev/?null_safety=true&id=0d065491139efd11c711ca6aa016d5e8
  // explain that it could also be done with `.whenData`
  final cartItems = await ref.watch(cartItemsListProvider.future);
  final matching = cartItems.where((item) => item.productId == product.id);
  final item = matching.isNotEmpty ? matching.first : null;
  final alreadyInCartQuantity = item != null ? item.quantity : 0;
  return max(0, product.availableQuantity - alreadyInCartQuantity);
});
