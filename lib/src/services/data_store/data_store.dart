import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart_total.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

abstract class AddressDataStore {
  Future<Address?> getAddress(String uid);

  Stream<Address?> address(String uid);

  Future<void> submitAddress(String uid, Address address);
}

abstract class ProductsDataStore {
  Stream<List<Product>> productsList();

  Stream<Product> product(String id);

  Future<void> addProduct(Product product);

  Future<void> editProduct(Product product);
}

abstract class OrdersDataStore {
  Stream<List<Order>> userOrders(String uid);

  Future<void> updateOrderStatus(Order order);

  Stream<List<Order>> allOrders();
}

abstract class CartDataStore {
  Future<List<Item>> getItemsList(String uid);

  Stream<List<Item>> itemsList(String uid);

  Stream<CartTotal> cartTotal(String uid);

  Future<void> addItem(String uid, Item item);

  Future<void> removeItem(String uid, Item item);

  Future<void> updateItemIfExists(String uid, Item item);

  // TODO: remote only
  Future<void> addAllItems(String uid, List<Item> items);
}

abstract class LocalCartDataStore {
  Future<List<Item>> getItemsList();

  Stream<List<Item>> itemsList();

  Stream<CartTotal> cartTotal(List<Product> products);

  Future<void> addItem(Item item);

  Future<void> removeItem(Item item);

  Future<void> updateItemIfExists(Item item);

  Future<void> clear();
}

abstract class DataStore
    implements
        ProductsDataStore,
        AddressDataStore,
        CartDataStore,
        OrdersDataStore {}

final dataStoreProvider = Provider<DataStore>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});

final localCartDataStoreProvider = Provider<LocalCartDataStore>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
