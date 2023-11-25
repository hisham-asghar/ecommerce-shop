import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';

abstract class ProductsRepository {
  Stream<List<Product>> productsList();

  Stream<Product> product(String id);

  Future<void> addProduct(Product product);

  Future<void> editProduct(Product product);
}

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
