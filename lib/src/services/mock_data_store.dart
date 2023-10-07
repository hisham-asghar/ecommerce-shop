import 'dart:async';

import 'package:faker/faker.dart' hide Address;
import 'package:my_shop_ecommerce_flutter/src/constants/app_assets.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';
import 'package:my_shop_ecommerce_flutter/src/services/mock_cart.dart';
import 'package:rxdart/rxdart.dart';

class MockDataStore implements DataStore {
  MockDataStore() {
    // Initialize all controllers
    _ordersDataSubject.add(ordersData);
  }
  // -------------------------------------
  // Address
  // -------------------------------------
  @override
  var isAddressSet = false;

  @override
  Future<void> submitAddress(Address address) async {
    await Future.delayed(const Duration(seconds: 2));
    isAddressSet = true;
  }

  // -------------------------------------
  // Products
  // -------------------------------------
  // default list of products when the app loads
  final List<Product> _products = kTestProducts;
  final _productsSubject = BehaviorSubject<List<Product>>.seeded(kTestProducts);
  Stream<List<Product>> get _productsStream => _productsSubject.stream;

  @override
  Stream<List<Product>> getProducts() {
    return _productsStream;
  }

  @override
  Future<void> addProduct(Product product) async {
    _products.add(product);
    _productsSubject.add(_products);
  }

  /// Throws error if not found
  @override
  Product findProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }
  // @override
  // Stream<Product> findProduct(String id) {
  //   return _productsStream
  //       .map((products) => products.firstWhere((product) => product.id == id));
  // }

  // -------------------------------------
  // Orders
  // -------------------------------------
  Map<String, Map<String, Order>> ordersData = {};
  final _ordersDataSubject = BehaviorSubject<Map<String, Map<String, Order>>>();
  Stream<Map<String, Map<String, Order>>> get _ordersDataStream =>
      _ordersDataSubject.stream;

  @override
  Stream<Map<String, Order>> orders(String uid) {
    return _ordersDataStream.map((ordersData) => ordersData[uid] ?? {});
  }

  @override
  Future<void> placeOrder(String uid, Order order) async {
    await Future.delayed(const Duration(seconds: 2));
    final userOrders = Map<String, Order>.from(ordersData[uid] ?? {});
    userOrders[order.id] = order;
    ordersData[uid] = userOrders;
    _ordersDataSubject.add(ordersData);
  }

  @override
  Future<void> updateOrderStatus(Order order, OrderStatus status) async {
    final userOrders = Map<String, Order>.from(ordersData[order.userId] ?? {});
    // TODO: Do this at the call site?
    final updated = order.copyWith(orderStatus: status);
    userOrders[order.id] = updated;
    ordersData[order.userId] = userOrders;
    _ordersDataSubject.add(ordersData);
  }

  @override
  Stream<List<Order>> ordersByDate(String uid) {
    return _ordersDataStream.map((ordersData) {
      final userOrders = ordersData[uid] ?? {};
      final ordersList = userOrders.values.toList();
      ordersList.sort(
        (lhs, rhs) => rhs.orderDate.compareTo(lhs.orderDate),
      );
      return ordersList;
    });
  }

  @override
  Stream<List<Order>> allOrdersByDate() {
    return _ordersDataStream.map((ordersData) {
      final orders = <Order>[];
      for (var userOrders in ordersData.values) {
        orders.addAll(userOrders.values);
      }
      orders.sort(
        (lhs, rhs) => rhs.orderDate.compareTo(lhs.orderDate),
      );
      return orders;
    });
  }

  // -------------------------------------
  // Shopping cart
  // -------------------------------------

  Map<String, List<Item>> cartData = {};

  @override
  List<Item> items(String uid) {
    return cartData[uid] ?? [];
  }

  @override
  void addItem(String uid, Item item) {
    final cart = MockCart(cartData[uid] ?? []);
    cart.addItem(item);
    cartData[uid] = cart.items;
  }

  @override
  void removeItem(String uid, Item item) {
    final cart = MockCart(cartData[uid] ?? []);
    cart.removeItem(item);
    cartData[uid] = cart.items;
  }

  @override
  bool updateItemIfExists(String uid, Item item) {
    final cart = MockCart(cartData[uid] ?? []);
    final result = cart.updateItemIfExists(item);
    if (result) {
      cartData[uid] = cart.items;
    }
    return result;
  }

  @override
  void removeAllItems(String uid) {
    cartData[uid] = [];
  }
}

final faker = Faker();
final kTestProducts = [
  Product(
    id: '1',
    imageUrl: AppAssets.sonyPlaystation4,
    title: 'Sony Playstation 4 Pro White Version',
    description: faker.lorem.sentence(),
    price: 399,
  ),
  Product(
    id: '2',
    imageUrl: AppAssets.amazonEchoDot3,
    title: 'Amazon Echo Dot 3rd Generation',
    description: faker.lorem.sentence(),
    price: 29,
  ),
  Product(
    id: '3',
    imageUrl: AppAssets.canonEos80d,
    title: 'Cannon EOS 80D DSLR Camera',
    description: faker.lorem.sentence(),
    price: 929,
  ),
  Product(
    id: '4',
    imageUrl: AppAssets.iPhone11Pro,
    title: 'iPhone 11 Pro 256GB Memory',
    description: faker.lorem.sentence(),
    price: 599,
  ),
];
