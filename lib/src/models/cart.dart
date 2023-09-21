import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

class Cart extends StateNotifier<List<CartItem>> {
  Cart() : super([]);

  // TODO: Unit tests
  void addItem(CartItem newItem) {
    final itemIndex = state.indexOf(newItem);
    // if item already exists, update quantity
    if (itemIndex >= 0) {
      final list = List<CartItem>.from(state);
      list[itemIndex] = CartItem(
          productId: newItem.productId,
          quantity: newItem.quantity + state[itemIndex].quantity);
      state = list;
      // else insert as new item
    } else {
      final list = List<CartItem>.from(state);
      list.add(newItem);
      state = list;
    }
  }

  static double total(List<CartItem> items) => items
      // first extract quantity * price for each item
      .map((item) => item.quantity * findProduct(item.productId).price)
      // then add them up
      .reduce((value, element) => value + element);
}

final cartProvider = StateNotifierProvider<Cart, List<CartItem>>((ref) {
  return Cart();
});
