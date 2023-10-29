import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class ProductsRepository {
  ProductsRepository({required this.dataStore});
  final DataStore dataStore;

  Future<void> addProduct(Product product) => dataStore.addProduct(product);

  Future<void> editProduct(Product product) => dataStore.editProduct(product);

  Product getProductById(String productId) => dataStore.getProduct(productId);

  // TODO: this should this be written by a Cloud function every time the cart
  // is updated
  double calculateTotal(List<Item> items) => items.isEmpty
      ? 0.0
      : items
          // first extract quantity * price for each item
          .map((item) =>
              item.quantity * dataStore.getProduct(item.productId).price)
          // then add them up
          .reduce((value, element) => value + element);
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
