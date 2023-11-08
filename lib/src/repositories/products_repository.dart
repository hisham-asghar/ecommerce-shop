import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class ProductsRepository {
  ProductsRepository({required this.dataStore});
  final DataStore dataStore;

  Future<void> addProduct(Product product) => dataStore.addProduct(product);

  Future<void> editProduct(Product product) => dataStore.editProduct(product);
}

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  return ProductsRepository(dataStore: dataStore);
});

final productsListProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  return dataStore.productsList();
});

final productProvider =
    StreamProvider.autoDispose.family<Product, String>((ref, id) {
  final dataStore = ref.watch(dataStoreProvider);
  return dataStore.product(id);
});

// alternative provider that returns a product if a productId is given, or null otherwise
final optionalProductProvider =
    StreamProvider.autoDispose.family<Product?, String?>((ref, id) {
  final dataStore = ref.watch(dataStoreProvider);
  if (id != null) {
    return dataStore.product(id);
  } else {
    return Stream.fromIterable([null]);
  }
});
