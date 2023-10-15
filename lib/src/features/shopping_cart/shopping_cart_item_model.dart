import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

// a StateNotifier subclass to manage the widget's state
class ShoppingCartItemModel extends StateNotifier<WidgetBasicState> {
  ShoppingCartItemModel({required this.cartRepository})
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

// provider for accessing the model
final shoppingCartItemModelProvider =
    StateNotifierProvider<ShoppingCartItemModel, WidgetBasicState>((ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  return ShoppingCartItemModel(cartRepository: cartRepository);
});
