import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

class Cart extends StateNotifier<List<CartItem>> {
  Cart() : super([]);

  void addItem(CartItem item) {
    final itemIndex = state.indexOf(item);
    // if item already exists, update quantity
    if (itemIndex >= 0) {
      final list = List<CartItem>.from(state);
      list[itemIndex] = CartItem(
          productId: item.productId,
          quantity: item.quantity + state[itemIndex].quantity);
      state = list;
      // else insert as new item
    } else {
      final list = List<CartItem>.from(state);
      list.add(item);
      state = list;
    }
  }

  void removeItem(CartItem item) {
    final list = List<CartItem>.from(state);
    list.remove(item);
    state = list;
  }

  bool updateItemIfExists(CartItem item) {
    final itemIndex = state.indexOf(item);
    if (itemIndex >= 0) {
      final list = List<CartItem>.from(state);
      list[itemIndex] = item;
      state = list;
      return true;
    } else {
      return false;
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
