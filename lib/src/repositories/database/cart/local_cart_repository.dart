import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_total.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';

abstract class LocalCartRepository {
  Future<List<Item>> getItemsList();

  Stream<List<Item>> itemsList();

  Stream<CartTotal> cartTotal(List<Product> products);

  Future<void> addItem(Item item);

  Future<void> removeItem(Item item);

  Future<void> updateItemIfExists(Item item);

  Future<void> clear();
}

final localCartRepositoryProvider = Provider<LocalCartRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
