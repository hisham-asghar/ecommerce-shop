import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class ProductsRepository {
  ProductsRepository({required this.dataStore});
  final DataStore dataStore;

  Future<void> addProduct(Product product) => dataStore.addProduct(product);

  Future<void> editProduct(Product product) => dataStore.editProduct(product);

  Product getProductById(String productId) =>
      dataStore.getProductById(productId);

  double calculateTotal(List<Item> items) => items.isEmpty
      ? 0.0
      : items
          // first extract quantity * price for each item
          .map((item) => item.quantity * getProductById(item.productId).price)
          // then add them up
          .reduce((value, element) => value + element);
}

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  return ProductsRepository(dataStore: dataStore);
});

final productsProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  return dataStore.getProducts();
});

final productRepository =
    StreamProvider.autoDispose.family<Product, String>((ref, id) {
  final dataStore = ref.watch(dataStoreProvider);
  return dataStore.product(id);
});
