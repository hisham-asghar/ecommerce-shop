import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/services/mutable_cart.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/remote/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
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
  Future<List<Item>> _fetchItemsList() {
    final user = authRepository.currentUser;
    if (user != null) {
      return cartRepository.fetchItemsList(user.uid);
    } else {
      return localCartRepository.fetchItemsList();
    }
  }

  /// helper method to save the items list to the local or remote cart
  /// depending on the user auth state
  Future<void> _setItemsList(List<Item> itemsList) async {
    final user = authRepository.currentUser;
    if (user != null) {
      await cartRepository.setItemsList(user.uid, itemsList);
    } else {
      await localCartRepository.setItemsList(itemsList);
    }
  }

  /// adds an item to the local or remote cart depending on the user auth state
  Future<void> addItem(Item item) async {
    final itemsList = await _fetchItemsList();
    final cart = MutableCart(itemsList)..addItem(item);
    await _setItemsList(cart.items);
  }

  /// removes an item from the local or remote cart depending on the user auth
  /// state
  Future<void> removeItem(Item item) async {
    final itemsList = await _fetchItemsList();
    final cart = MutableCart(itemsList)..removeItem(item);
    await _setItemsList(cart.items);
  }

  /// updates an item in the local or remote cart depending on the user auth
  /// state
  Future<void> updateItemIfExists(Item item) async {
    final itemsList = await _fetchItemsList();
    final cart = MutableCart(itemsList)..updateItemIfExists(item);
    await _setItemsList(cart.items);
  }

  /// copies all items from the local to the remote cart taking into account the
  /// available quantities
  Future<void> copyItemsToRemote() async {
    final user = authRepository.currentUser;
    if (user != null) {
      try {
        final localItems = await localCartRepository.fetchItemsList();
        if (localItems.isNotEmpty) {
          // Get the available quantity for each product (by id)
          final products = await productsRepository.fetchProductsList();
          var availableQuantities = <String, int>{};
          for (final product in products) {
            availableQuantities[product.id] = product.availableQuantity;
          }
          // Cap the quantity of each item to the available quantity
          final remoteItems = await cartRepository.fetchItemsList(user.uid);
          final localItemsToAdd = <Item>[];
          for (final item in localItems) {
            final matching =
                remoteItems.where((item) => item.productId == item.productId);
            final remoteItemQuantity =
                matching.isNotEmpty ? matching.first.quantity : 0;
            final availableQuantity = availableQuantities[item.productId];
            if (availableQuantity != null) {
              final newAvailableQuantity =
                  availableQuantity - remoteItemQuantity;
              final localItem = item.copyWith(
                  quantity: min(item.quantity, newAvailableQuantity));
              localItemsToAdd.add(localItem);
            } else {
              debugPrint('Product with id ${item.productId} not found');
            }
          }
          // Add all items to the remote cart
          final cart = MutableCart(remoteItems);
          for (var item in localItemsToAdd) {
            cart.addItem(item);
          }
          await cartRepository.setItemsList(user.uid, cart.items);
          // Remove all items from the local cart
          await localCartRepository.setItemsList([]);
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

final cartItemsListProvider = StreamProvider.autoDispose<List<Item>>((ref) {
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.value;
  if (user != null) {
    final cartRepository = ref.watch(cartRepositoryProvider);
    return cartRepository.watchItemsList(user.uid);
  } else {
    final localCartRepository = ref.watch(localCartRepositoryProvider);
    return localCartRepository.watchItemsList();
  }
});

// Using a regular Provider so that we don't have to deal with async UI updates
final cartTotalProvider = Provider.autoDispose<double>((ref) {
  final productsListValue = ref.watch(productsListProvider);
  final productsList = productsListValue.value ?? [];
  final itemsValue = ref.watch(cartItemsListProvider);
  final items = itemsValue.value ?? [];
  if (items.isNotEmpty && productsList.isNotEmpty) {
    final itemPrices = items.map((item) {
      final product =
          productsList.firstWhere((product) => product.id == item.productId);
      return product.price * item.quantity;
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
  final cartItems = ref.watch(cartItemsListProvider).value ?? [];
  final matching = cartItems.where((item) => item.productId == product.id);
  final item = matching.isNotEmpty ? matching.first : null;
  final alreadyInCartQuantity = item != null ? item.quantity : 0;
  return max(0, product.availableQuantity - alreadyInCartQuantity);
});
