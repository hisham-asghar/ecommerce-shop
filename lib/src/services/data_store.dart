import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/mock_data_store.dart';

abstract class DataStore {
  // -------------------------------------
  // Address
  // -------------------------------------
  Address? getAddress(String uid);
  Stream<Address?> address(String uid);
  Future<void> submitAddress(String uid, Address address);

  // -------------------------------------
  // Products
  // -------------------------------------
  Stream<List<Product>> productsList();
  // Read from cache
  Product getProduct(String id);
  // Realtime
  Stream<Product> product(String id);

  Future<void> addProduct(Product product);

  Future<void> editProduct(Product product);

  // -------------------------------------
  // Orders
  // -------------------------------------
  // Read from cache
  Map<String, Order> getOrders(String uid);
  // Realtime
  Stream<Map<String, Order>> orders(String uid);

  Future<void> placeOrder(String uid, Order order);

  Future<void> updateOrderStatus(Order order, OrderStatus status);

  Stream<List<Order>> ordersByDate(String uid);

  Stream<List<Order>> allOrdersByDate();

  // -------------------------------------
  // Shopping Cart
  // -------------------------------------
  // TODO: Add a method to read the cart total value
  // Read from cache
  Future<List<Item>> getItemsList(String uid);
  // Realtime
  Stream<List<Item>> itemsList(String uid);

  Future<void> addItem(String uid, Item item);

  Future<void> removeItem(String uid, Item item);

  Future<void> updateItemIfExists(String uid, Item item);

  Future<void> removeAllItems(String uid);
}

final dataStoreProvider = Provider<DataStore>((ref) {
  return MockDataStore();
});
