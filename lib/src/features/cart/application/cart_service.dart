import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:my_shop_ecommerce_flutter/src/exceptions/app_exception.dart';
import 'package:my_shop_ecommerce_flutter/src/exceptions/run_catching_exceptions.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/local_cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/remote_cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/item.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/mutable_cart.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/application/products_service.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/domain/product.dart';

class CartService {
  CartService({
    required this.authRepository,
    required this.cartRepository,
    required this.localCartRepository,
  });
  final AuthRepository authRepository;
  final CartRepository cartRepository;
  final LocalCartRepository localCartRepository;

  /// helper method to fetch the items list from the local or remote cart
  /// depending on the user auth state
  Future<Cart> _fetchCart() {
    final user = authRepository.currentUser;
    if (user != null) {
      return cartRepository.fetchCart(user.uid);
    } else {
      return localCartRepository.fetchCart();
    }
  }

  /// helper method to save the items list to the local or remote cart
  /// depending on the user auth state
  Future<void> _setCart(Cart cart) async {
    final user = authRepository.currentUser;
    if (user != null) {
      await cartRepository.setCart(user.uid, cart);
    } else {
      await localCartRepository.setCart(cart);
    }
  }

  /// adds an item to the local or remote cart depending on the user auth state
  Future<Result<AppException, void>> addItem(Item item) =>
      runCatchingExceptions(() async {
        final cart = await _fetchCart();
        final updated = cart.addItem(item);
        await _setCart(updated);
      });

  /// removes an item from the local or remote cart depending on the user auth
  /// state
  Future<Result<AppException, void>> removeItem(Item item) =>
      runCatchingExceptions(() async {
        // business logic
        final cart = await _fetchCart();
        final updated = cart.removeItemById(item.productId);
        await _setCart(updated);
      });

  /// updates an item in the local or remote cart depending on the user auth
  /// state
  Future<Result<AppException, void>> updateItemIfExists(Item item) =>
      runCatchingExceptions(() async {
        final cart = await _fetchCart();
        final updated = cart.updateItemIfExists(item);
        await _setCart(updated);
      });
}

final cartServiceProvider = Provider<CartService>((ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  final localCartRepository = ref.watch(localCartRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return CartService(
    authRepository: authRepository,
    cartRepository: cartRepository,
    localCartRepository: localCartRepository,
  );
});

final cartProvider = StreamProvider.autoDispose<Cart>((ref) {
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.value;
  if (user != null) {
    final cartRepository = ref.watch(cartRepositoryProvider);
    return cartRepository.watchCart(user.uid);
  } else {
    final localCartRepository = ref.watch(localCartRepositoryProvider);
    return localCartRepository.watchCart();
  }
});

// Using a regular Provider so that we don't have to deal with async UI updates
final cartTotalProvider = Provider.autoDispose<double>((ref) {
  // TODO Fix this: https://github.com/bizz84/my_shop_ecommerce_flutter/issues/239
  final productsListValue = ref.watch(productsListProvider);
  final productsList = productsListValue.value ?? [];
  final cart = ref.watch(cartProvider).value ?? const Cart();
  if (cart.items.isNotEmpty && productsList.isNotEmpty) {
    final itemPrices = cart.items.entries.map((item) {
      final product =
          productsList.firstWhere((product) => product.id == item.key);
      return product.price * item.value;
    }).toList();
    return itemPrices.reduce((value, itemPrice) {
      return value + itemPrice;
    });
  } else {
    return 0.0;
  }
});

// calculates the available quantity of the product
// given how many items are already in the cart
final itemAvailableQuantityProvider =
    FutureProvider.autoDispose.family<int, Product>((ref, product) async {
  // simple example of how this works:
  // https://dartpad.dev/?null_safety=true&id=0d065491139efd11c711ca6aa016d5e8
  // explain that it could also be done with `.whenData`
  // TODO: Fix #133: The provider AutoDisposeStreamProvider was disposed before a value was emitted
  //final cartItems = await ref.watch(cartItemsListProvider.future);
  final cart = ref.watch(cartProvider).value ?? const Cart();
  final quantity = cart.items[product.id] ?? 0;
  return max(0, product.availableQuantity - quantity);
});
