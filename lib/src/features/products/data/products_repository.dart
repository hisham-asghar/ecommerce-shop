import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/domain/product.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/search_repository.dart';

abstract class ProductsRepository implements SearchRepository {
  Future<List<Product>> fetchProductsList();

  Stream<List<Product>> watchProductsList();

  Stream<Product?> product(String id);

  Future<void> createProduct(Product product);

  Future<void> updateProduct(Product product);
}

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
