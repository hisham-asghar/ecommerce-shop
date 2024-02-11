import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_provider.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// a StateNotifier subclass to manage the widget's state
class ShoppingCartItemController extends StateNotifier<VoidAsyncValue> {
  ShoppingCartItemController(
      {required this.localizations, required this.cartService})
      : super(const VoidAsyncValue.data(null));
  final AppLocalizations localizations;
  final CartService cartService;

  Future<void> updateQuantity(Item item, int quantity) async {
    state = const VoidAsyncValue.loading();
    final updated = Item(productId: item.productId, quantity: quantity);
    final result = await cartService.updateItemIfExists(updated);
    result.when(
      (error) => state = VoidAsyncValue.error(localizations.cantUpdateQuantity),
      (success) => state = const VoidAsyncValue.data(null),
    );
  }

  Future<void> deleteItem(Item item) async {
    state = const VoidAsyncValue.loading();
    final result = await cartService.removeItem(item);
    result.when(
      (error) => state = VoidAsyncValue.error(localizations.cantDeleteItem),
      (success) => state = const VoidAsyncValue.data(null),
    );
  }
}

// provider for accessing the model
final shoppingCartItemControllerProvider =
    StateNotifierProvider<ShoppingCartItemController, VoidAsyncValue>((ref) {
  final cartRepository = ref.watch(cartServiceProvider);
  final localizations = ref.watch(appLocalizationsProvider);
  return ShoppingCartItemController(
    localizations: localizations,
    cartService: cartRepository,
  );
});
