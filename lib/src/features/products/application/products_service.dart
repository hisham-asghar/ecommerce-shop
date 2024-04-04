import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/domain/product.dart';

final productsListProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProductsList();
});

final productProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.product(id);
});

// alternative provider that returns a product if a productId is given, or null otherwise
final optionalProductProvider =
    StreamProvider.autoDispose.family<Product?, String?>((ref, id) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  if (id != null) {
    return productsRepository.product(id);
  } else {
    return Stream.value(null);
  }
});
