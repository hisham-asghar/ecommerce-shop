import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class ShoppingCartItemViewModel extends StateNotifier<WidgetBasicState> {
  ShoppingCartItemViewModel({required this.cartRepository})
      : super(const WidgetBasicState.notLoading());
  final CartRepository cartRepository;

  Future<void> updateQuantity(Item item, int quantity) async {
    try {
      state = const WidgetBasicState.loading();
      final updated = Item(productId: item.productId, quantity: quantity);
      await cartRepository.updateItemIfExists(updated);
    } catch (e) {
      state = const WidgetBasicState.error('Could not update quantity');
    } finally {
      state = const WidgetBasicState.notLoading();
    }
  }

  Future<void> deleteItem(Item item) async {
    try {
      state = const WidgetBasicState.loading();
      await cartRepository.removeItem(item);
    } catch (e) {
      state = const WidgetBasicState.error('Could not delete item');
    } finally {
      state = const WidgetBasicState.notLoading();
    }
  }
}

final shoppingCartItemViewModelProvider =
    StateNotifierProvider<ShoppingCartItemViewModel, WidgetBasicState>((ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  return ShoppingCartItemViewModel(cartRepository: cartRepository);
});
