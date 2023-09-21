import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

class CartItem {
  CartItem({required this.productId, required this.quantity})
      : assert(quantity > 0);
  final String productId;
  final int quantity;
}

class Cart extends StateNotifier<List<CartItem>> {
  Cart() : super([]);

  void addItem(CartItem item) {
    // TODO: Implement properly
    final newState = List<CartItem>.from(state);
    newState.add(item);
    state = newState;
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
