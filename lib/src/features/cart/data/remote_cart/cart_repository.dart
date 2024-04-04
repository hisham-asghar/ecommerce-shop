import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/cart.dart';

abstract class CartRepository {
  Future<Cart> fetchCart(String uid);

  Stream<Cart> watchCart(String uid);

  Future<void> setCart(String uid, Cart cart);
}

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
