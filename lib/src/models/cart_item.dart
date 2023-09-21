import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

final cartProvider = StateNotifierProvider<Cart, List<CartItem>>((ref) {
  return Cart();
});
