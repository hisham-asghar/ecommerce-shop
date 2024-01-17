import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';

class ProductsService {
  ProductsService({required this.productsRepository});
  final ProductsRepository productsRepository;

  Future<void> addProduct(Product product) =>
      productsRepository.createProduct(product);

  Future<void> editProduct(Product product) =>
      productsRepository.updateProduct(product);
}

final productsServiceProvider = Provider<ProductsService>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return ProductsService(productsRepository: productsRepository);
});

final productsListProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProductsList();
});

final productProvider =
    StreamProvider.autoDispose.family<Product, String>((ref, id) {
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
    return Stream.fromIterable([null]);
  }
});
