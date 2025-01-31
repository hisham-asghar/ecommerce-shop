import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/application/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/item.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/presentation/add_to_cart/add_to_cart_state.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_provider.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/domain/product.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddToCartController extends StateNotifier<AddToCartState> {
  AddToCartController({
    required this.localizations,
    required this.cartService,
    required this.product,
  }) : super(AddToCartState(
          quantity: 1,
          widgetState: const VoidAsyncValue.data(null),
        ));
  final AppLocalizations localizations;
  final CartService cartService;
  final Product product;

  void updateQuantity(int quantity) {
    state = state.copyWith(quantity: quantity);
  }

  Future<void> addItem() async {
    state = state.copyWith(widgetState: const VoidAsyncValue.loading());
    final item = Item(
      productId: product.id,
      quantity: state.quantity,
    );
    final result = await cartService.addItem(item);
    result.when(
      (error) => state = state.copyWith(
        widgetState: VoidAsyncValue.error(localizations.cantAddItemToCart),
      ),
      (success) => state = state.copyWith(
        quantity: 1,
        widgetState: const VoidAsyncValue.data(null),
      ),
    );
  }
}

final addToCartControllerProvider =
    StateNotifierProvider.family<AddToCartController, AddToCartState, Product>(
        (ref, product) {
  final localizations = ref.watch(appLocalizationsProvider);
  final cartRepository = ref.watch(cartServiceProvider);
  return AddToCartController(
    localizations: localizations,
    cartService: cartRepository,
    product: product,
  );
});
