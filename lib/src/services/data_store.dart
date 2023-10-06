import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/mock_data_store.dart';

abstract class DataStore {
  // TODO: This should depend on the authenticated user
  // Address
  bool get isAddressSet;
  Future<void> submitAddress(Address address);

  // Products
  List<Product> getProducts();

  void addProduct(Product product);

  Product findProduct(String id);

  // Orders
  Map<String, Order> get orders;

  Future<void> placeOrder(Order order);

  List<Order> get ordersByDate;

  // Shopping Cart
  List<Item> items(String uid);

  void addItem(String uid, Item item);

  void removeItem(String uid, Item item);

  bool updateItemIfExists(String uid, Item item);

  void removeAllItems(String uid);
}

final dataStoreProvider = Provider<DataStore>((ref) {
  return MockDataStore();
});
