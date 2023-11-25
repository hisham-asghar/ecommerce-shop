import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/item.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

// a StateNotifier subclass to manage the widget's state
class ShoppingCartItemController extends StateNotifier<WidgetBasicState> {
  ShoppingCartItemController({required this.cartService})
      : super(const WidgetBasicState.notLoading());
  final CartService cartService;

  Future<void> updateQuantity(Item item, int quantity) async {
    try {
      state = const WidgetBasicState.loading();
      final updated = Item(productId: item.productId, quantity: quantity);
      await cartService.updateItemIfExists(updated);
    } catch (e) {
      state = const WidgetBasicState.error('Could not update quantity');
    } finally {
      state = const WidgetBasicState.notLoading();
    }
  }

  Future<void> deleteItem(Item item) async {
    try {
      state = const WidgetBasicState.loading();
      await cartService.removeItem(item);
    } catch (e) {
      state = const WidgetBasicState.error('Could not delete item');
    } finally {
      state = const WidgetBasicState.notLoading();
    }
  }
}

// provider for accessing the model
final shoppingCartItemControllerProvider =
    StateNotifierProvider<ShoppingCartItemController, WidgetBasicState>((ref) {
  final cartRepository = ref.watch(cartServiceProvider);
  return ShoppingCartItemController(cartService: cartRepository);
});
