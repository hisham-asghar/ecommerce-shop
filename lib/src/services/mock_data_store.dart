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
  Stream<List<Product>> productsList() {
    return _productsStream;
  }

  @override
  Stream<Product> product(String id) {
    return _productsStream
        .map((products) => products.firstWhere((product) => product.id == id));
  }

  @override
  Future<void> addProduct(Product product) async {
    _products.add(product);
    _productsSubject.add(_products);
  }

  @override
  Future<void> editProduct(Product product) async {
    final index = _products.indexWhere((item) => item.id == product.id);
    if (index == -1) {
      throw AssertionError('Product not found (id: ${product.id}');
    }
    _products[index] = product;
    _productsSubject.add(_products);
  }

  /// Throws error if not found
  @override
  Product getProductById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  @override
  Stream<Product> productById(String id) {
    return _productsStream
        .map((products) => products.firstWhere((product) => product.id == id));
  }

  // TODO: Methods to edit products

  // -------------------------------------
  // Orders
  // -------------------------------------
  Map<String, Map<String, Order>> ordersData = {};
  final _ordersDataSubject =
      BehaviorSubject<Map<String, Map<String, Order>>>.seeded({});
  Stream<Map<String, Map<String, Order>>> get _ordersDataStream =>
      _ordersDataSubject.stream;

  @override
  Map<String, Order> getOrders(String uid) {
    return ordersData[uid] ?? {};
  }

  @override
  Stream<Map<String, Order>> orders(String uid) {
    return _ordersDataStream.map((ordersData) => ordersData[uid] ?? {});
  }

  @override
  Future<void> placeOrder(String uid, Order order) async {
    await Future.delayed(const Duration(seconds: 2));
    // First, make sure all items are available
    for (var item in order.items) {
      final product = getProductById(item.productId);
      if (product.availableQuantity < item.quantity) {
        throw AssertionError(
            'Can\'t purchase ${item.quantity} quantity of $product');
      }
    }
    // then, place the order
    final userOrders = Map<String, Order>.from(ordersData[uid] ?? {});
    userOrders[order.id] = order;
    ordersData[uid] = userOrders;
    _ordersDataSubject.add(ordersData);
    // and update all the product quantities
    for (var item in order.items) {
      final product = getProductById(item.productId);
      final updated = product.copyWith(
          availableQuantity: product.availableQuantity - item.quantity);
      editProduct(updated);
    }
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
  final _cartDataSubject = BehaviorSubject<Map<String, List<Item>>>.seeded({});
  Stream<Map<String, List<Item>>> get _cartDataStream =>
      _cartDataSubject.stream;

  @override
  List<Item> getItemsList(String uid) {
    return cartData[uid] ?? [];
  }

  @override
  Stream<List<Item>> itemsList(String uid) {
    return _cartDataStream.map((cartData) {
      return cartData[uid] ?? [];
    });
  }

  @override
  Future<void> addItem(String uid, Item item) async {
    final cart = MockCart(cartData[uid] ?? []);
    cart.addItem(item);
    cartData[uid] = cart.items;
    _cartDataSubject.add(cartData);
  }

  @override
  Future<void> removeItem(String uid, Item item) async {
    final cart = MockCart(cartData[uid] ?? []);
    cart.removeItem(item);
    cartData[uid] = cart.items;
    _cartDataSubject.add(cartData);
  }

  @override
  Future<bool> updateItemIfExists(String uid, Item item) async {
    final cart = MockCart(cartData[uid] ?? []);
    final result = cart.updateItemIfExists(item);
    if (result) {
      cartData[uid] = cart.items;
      _cartDataSubject.add(cartData);
    }
    return result;
  }

  @override
  Future<void> removeAllItems(String uid) async {
    cartData[uid] = [];
    _cartDataSubject.add(cartData);
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
    availableQuantity: 5,
  ),
  Product(
    id: '2',
    imageUrl: AppAssets.amazonEchoDot3,
    title: 'Amazon Echo Dot 3rd Generation',
    description: faker.lorem.sentence(),
    price: 29,
    availableQuantity: 5,
  ),
  Product(
    id: '3',
    imageUrl: AppAssets.canonEos80d,
    title: 'Cannon EOS 80D DSLR Camera',
    description: faker.lorem.sentence(),
    price: 929,
    availableQuantity: 5,
  ),
  Product(
    id: '4',
    imageUrl: AppAssets.iPhone11Pro,
    title: 'iPhone 11 Pro 256GB Memory',
    description: faker.lorem.sentence(),
    price: 599,
    availableQuantity: 5,
  ),
];
