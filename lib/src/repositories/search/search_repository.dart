import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

abstract class SearchRepository {
  Future<List<Product>> searchProducts(String text);
}

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
