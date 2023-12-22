import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/services/products_service.dart';

class CartService {
  CartService(
      {required this.authRepository,
      required this.cartRepository,
      required this.localCartRepository,
      required this.productsRepository,
      required this.cloudFunctions});
  final AuthRepository authRepository;
  final CartRepository cartRepository;
  final LocalCartRepository localCartRepository;
  final ProductsRepository productsRepository;
  final CloudFunctionsRepository cloudFunctions;

  Future<List<Item>> getItemsList() {
    final user = authRepository.currentUser;
    if (user != null) {
      return cartRepository.getItemsList(user.uid);
    } else {
      return localCartRepository.getItemsList();
    }
  }

  Future<void> addItem(Item item) {
    final user = authRepository.currentUser;
    if (user != null) {
      // This will replace the item quantity if it already exists
      return cartRepository.addItem(user.uid, item);
    } else {
      return localCartRepository.addItem(item);
    }
  }

  Future<void> removeItem(Item item) {
    final user = authRepository.currentUser;
    if (user != null) {
      return cartRepository.removeItem(user.uid, item);
    } else {
      return localCartRepository.removeItem(item);
    }
  }

  Future<void> updateItemIfExists(Item item) {
    // Is there a way to cache this so updates are faster?
    final user = authRepository.currentUser;
    if (user != null) {
      return cartRepository.updateItemIfExists(user.uid, item);
    } else {
      return localCartRepository.updateItemIfExists(item);
    }
  }

  Future<void> copyItemsToRemote() async {
    final user = authRepository.currentUser;
    if (user != null) {
      try {
        final localItems = await localCartRepository.getItemsList();
        if (localItems.isNotEmpty) {
          // Get the available quantity for each product (by id)
          final products = await productsRepository.getProductsList();
          var availableQuantities = <String, int>{};
          for (final product in products) {
            availableQuantities[product.id] = product.availableQuantity;
          }
          // Cap the quantity of each item to the available quantity
          final remoteItems = await cartRepository.getItemsList(user.uid);
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
              print('Product with id ${item.productId} not found');
            }
          }
          // Add all items to the remote cart
          await cartRepository.addAllItems(user.uid, localItemsToAdd);
          // Remove all items from the local cart
          await localCartRepository.clear();
        }
      } catch (e, _) {
        // TODO: Report error
        print(e);
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
  final authService = ref.watch(authRepositoryProvider);
  final cloudFunctions = ref.watch(cloudFunctionsRepositoryProvider);
  return CartService(
    authRepository: authService,
    cartRepository: cartRepository,
    localCartRepository: localCartRepository,
    productsRepository: productsRepository,
    cloudFunctions: cloudFunctions,
  );
});

final cartItemsListProvider = StreamProvider.autoDispose<List<Item>>((ref) {
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.asData?.value;
  if (user != null) {
    final cartRepository = ref.watch(cartRepositoryProvider);
    return cartRepository.itemsList(user.uid);
  } else {
    final localCartRepository = ref.watch(localCartRepositoryProvider);
    return localCartRepository.itemsList();
  }
});

// Using a regular Provider so that we don't have to deal with async UI updates
final cartTotalProvider = Provider.autoDispose<double>((ref) {
  final productsListValue = ref.watch(productsListProvider);
  final productsList = productsListValue.value ?? [];
  final itemsValue = ref.watch(cartItemsListProvider);
  final items = itemsValue.value ?? [];
  if (items.isNotEmpty) {
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
  final cartItems = await ref.watch(cartItemsListProvider.future);
  final matching = cartItems.where((item) => item.productId == product.id);
  final item = matching.isNotEmpty ? matching.first : null;
  final alreadyInCartQuantity = item != null ? item.quantity : 0;
  return max(0, product.availableQuantity - alreadyInCartQuantity);
});
