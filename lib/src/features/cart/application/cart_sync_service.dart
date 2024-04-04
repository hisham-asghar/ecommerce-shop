import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:my_shop_ecommerce_flutter/src/exceptions/app_exception.dart';
import 'package:my_shop_ecommerce_flutter/src/exceptions/run_catching_exceptions.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/local_cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/remote_cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/item.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/mutable_cart.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/products_repository.dart';

class CartSyncService {
  CartSyncService({
    required this.cartRepository,
    required this.localCartRepository,
    required this.productsRepository,
  });
  final CartRepository cartRepository;
  final LocalCartRepository localCartRepository;
  final ProductsRepository productsRepository;

  /// moves all items from the local to the remote cart taking into account the
  /// available quantities
  Future<Result<AppException, void>> moveItemsToRemote(String uid) =>
      runCatchingExceptions(() async {
        final localCart = await localCartRepository.fetchCart();
        if (localCart.items.isNotEmpty) {
          // Get the available quantity for each product (by id)
          final products = await productsRepository.fetchProductsList();
          var availableQuantities = <String, int>{};
          for (final product in products) {
            availableQuantities[product.id] = product.availableQuantity;
          }
          // Cap the quantity of each item to the available quantity
          final remoteCart = await cartRepository.fetchCart(uid);
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
              // TODO: Error reporting
            }
          }
          // Add all items to the remote cart
          final updatedCart = remoteCart.addItems(localItemsToAdd);
          await cartRepository.setCart(uid, updatedCart);
          // Remove all items from the local cart
          await localCartRepository.setCart(const Cart());
        }
      });
}

final cartSyncServiceProvider = Provider<CartSyncService>((ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  final localCartRepository = ref.watch(localCartRepositoryProvider);
  final productsRepository = ref.watch(productsRepositoryProvider);
  return CartSyncService(
    cartRepository: cartRepository,
    localCartRepository: localCartRepository,
    productsRepository: productsRepository,
  );
});
