import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

// a StateNotifier subclass to manage the widget's state
class ShoppingCartItemController extends StateNotifier<VoidAsyncValue> {
  ShoppingCartItemController({required this.cartService})
      : super(const VoidAsyncValue.data(null));
  final CartService cartService;

  Future<void> updateQuantity(Item item, int quantity) async {
    try {
      state = const VoidAsyncValue.loading();
      final updated = Item(productId: item.productId, quantity: quantity);
      await cartService.updateItemIfExists(updated);
    } catch (e) {
      state = const VoidAsyncValue.error('Could not update quantity');
    } finally {
      state = const VoidAsyncValue.data(null);
    }
  }

  Future<void> deleteItem(Item item) async {
    try {
      state = const VoidAsyncValue.loading();
      await cartService.removeItem(item);
    } catch (e) {
      state = const VoidAsyncValue.error('Could not delete item');
    } finally {
      state = const VoidAsyncValue.data(null);
    }
  }
}

// provider for accessing the model
final shoppingCartItemControllerProvider =
    StateNotifierProvider<ShoppingCartItemController, VoidAsyncValue>((ref) {
  final cartRepository = ref.watch(cartServiceProvider);
  return ShoppingCartItemController(cartService: cartRepository);
});
