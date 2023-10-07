import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class ProductsRepository {
  ProductsRepository({required this.dataStore});
  final DataStore dataStore;

  Future<void> addProduct(Product product) => dataStore.addProduct(product);

  Product findProduct(String productId) => dataStore.findProduct(productId);

  double calculateTotal(List<Item> items) => items.isEmpty
      ? 0.0
      : items
          // first extract quantity * price for each item
          .map((item) => item.quantity * findProduct(item.productId).price)
          // then add them up
          .reduce((value, element) => value + element);
}

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  return ProductsRepository(dataStore: dataStore);
});

final productsProvider = StreamProvider<List<Product>>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  return dataStore.getProducts();
});
