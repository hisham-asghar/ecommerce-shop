import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/search/search_repository.dart';

abstract class ProductsRepository implements SearchRepository {
  Future<List<Product>> getProductsList();

  Stream<List<Product>> productsList();

  Stream<Product> product(String id);

  Future<void> addProduct(Product product);

  Future<void> editProduct(Product product);
}

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
