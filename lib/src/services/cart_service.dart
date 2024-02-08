import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/models/mutable_cart.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/remote/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/services/products_service.dart';

class CartService {
  CartService({
    required this.authRepository,
    required this.cartRepository,
    required this.localCartRepository,
    required this.productsRepository,
    required this.cloudFunctions,
  });
  final AuthRepository authRepository;
  final CartRepository cartRepository;
  final LocalCartRepository localCartRepository;
  final ProductsRepository productsRepository;
  final CloudFunctionsRepository cloudFunctions;

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
  Future<void> addItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.addItem(item);
    await _setCart(updated);
  }

  /// removes an item from the local or remote cart depending on the user auth
  /// state
  Future<void> removeItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.removeItem(item);
    await _setCart(updated);
  }

  /// updates an item in the local or remote cart depending on the user auth
  /// state
  Future<void> updateItemIfExists(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.updateItemIfExists(item);
    await _setCart(updated);
  }

  /// copies all items from the local to the remote cart taking into account the
  /// available quantities
  Future<void> copyItemsToRemote() async {
    final user = authRepository.currentUser;
    if (user != null) {
      try {
        final localCart = await localCartRepository.fetchCart();
        if (localCart.items.isNotEmpty) {
          // Get the available quantity for each product (by id)
          final products = await productsRepository.fetchProductsList();
          var availableQuantities = <String, int>{};
          for (final product in products) {
            availableQuantities[product.id] = product.availableQuantity;
          }
          // Cap the quantity of each item to the available quantity
          final remoteCart = await cartRepository.fetchCart(user.uid);
          final localItemsToAdd = <Item>[];
          for (final localItem in localCart.items.entries) {
            final remoteQuantity = remoteCart.items[localItem.key] ?? 0;
            final availableQuantity = availableQuantities[localItem.key];
            if (availableQuantity != null) {
              final newAvailableQuantity = availableQuantity - remoteQuantity;
              final localItemQuantity =
                  min(localItem.value, newAvailableQuantity);
              localItemsToAdd.add(
                  Item(productId: localItem.key, quantity: localItemQuantity));
            } else {
              debugPrint('Product with id ${localItem.key} not found');
            }
          }
          // Add all items to the remote cart
          final updatedCart = remoteCart.addItems(localItemsToAdd);
          await cartRepository.setCart(user.uid, updatedCart);
          // Remove all items from the local cart
          await localCartRepository.setCart(const Cart());
        }
      } catch (e, _) {
        // TODO: Report error
        debugPrint(e.toString());
        rethrow;
      }
    } else {
      throw AssertionError('user uid == null');
    }
  }
}

final cartServiceProvider = Provider<CartService>((ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  final localCartRepository = ref.watch(localCartRepositoryProvider);
  final productsRepository = ref.watch(productsRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final cloudFunctions = ref.watch(cloudFunctionsRepositoryProvider);
  return CartService(
    authRepository: authRepository,
    cartRepository: cartRepository,
    localCartRepository: localCartRepository,
    productsRepository: productsRepository,
    cloudFunctions: cloudFunctions,
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
