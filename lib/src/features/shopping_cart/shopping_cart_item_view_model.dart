import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item_state.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cart_repository.dart';

class ShoppingCartItemViewModel extends StateNotifier<ShoppingCartItemState> {
  ShoppingCartItemViewModel({required this.cartRepository})
      : super(ShoppingCartItemState(isLoading: false));
  final CartRepository cartRepository;

  Future<void> updateQuantity(Item item, int quantity) async {
    try {
      state = state.copyWith(isLoading: true);
      final updated = Item(productId: item.productId, quantity: quantity);
      await cartRepository.updateItemIfExists(updated);
    } catch (e) {
      print(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> deleteItem(Item item) async {
    try {
      state = state.copyWith(isLoading: true);
      await cartRepository.removeItem(item);
    } catch (e) {
      print(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final shoppingCartItemViewModelProvider =
    StateNotifierProvider<ShoppingCartItemViewModel, ShoppingCartItemState>(
        (ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  return ShoppingCartItemViewModel(cartRepository: cartRepository);
});
