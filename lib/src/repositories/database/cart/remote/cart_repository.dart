import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';

abstract class CartRepository {
  Future<List<Item>> fetchItemsList(String uid);

  Stream<List<Item>> watchItemsList(String uid);

  Future<void> setItemsList(String uid, List<Item> items);
}

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
