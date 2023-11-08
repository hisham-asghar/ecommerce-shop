import 'dart:async';

import 'package:faker/faker.dart' hide Address;
import 'package:my_shop_ecommerce_flutter/src/constants/app_assets.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart_total.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store/data_store.dart';
import 'package:my_shop_ecommerce_flutter/src/services/mock_cart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class MockDataStore implements DataStore {
  MockDataStore() {
    // Initialize all controllers
    _ordersDataSubject.add(ordersData);
  }
  // -------------------------------------
  // Address
  // -------------------------------------
  final Map<String, Address> _addressData = {};
  final _addressDataSubject = BehaviorSubject<Map<String, Address>>.seeded({});
  Stream<Map<String, Address>> get _addressDataStream =>
      _addressDataSubject.stream;

  @override
  Future<Address?> getAddress(String uid) {
    return Future.value(_addressData[uid]);
  }

  @override
  Stream<Address?> address(String uid) {
    return _addressDataStream.map((addressData) => addressData[uid]);
  }

  @override
  Future<void> submitAddress(String uid, Address address) async {
    await _delay();
    _addressData[uid] = address;
    _addressDataSubject.add(_addressData);
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
    await _delay();
    final productWithId = product.copyWith(id: const Uuid().v1());
    _products.add(productWithId);
    _productsSubject.add(_products);
  }

  @override
  Future<void> editProduct(Product product) async {
    await _delay();
    final index = _products.indexWhere((item) => item.id == product.id);
    if (index == -1) {
      throw AssertionError('Product not found (id: ${product.id}');
    }
    _products[index] = product;
    _productsSubject.add(_products);
  }

  // TODO: Methods to edit products

  // -------------------------------------
  // Orders
  // -------------------------------------
  Map<String, List<Order>> ordersData = {};
  final _ordersDataSubject =
      BehaviorSubject<Map<String, List<Order>>>.seeded({});
  Stream<Map<String, List<Order>>> get _ordersDataStream =>
      _ordersDataSubject.stream;

  @override
  Stream<List<Order>> userOrders(String uid) {
    return _ordersDataStream.map((ordersData) {
      final ordersList = ordersData[uid] ?? [];
      ordersList.sort(
        (lhs, rhs) => rhs.orderDate.compareTo(lhs.orderDate),
      );
      return ordersList;
    });
  }

  // Not overridden, only available from MockCloudFunctions
  Future<Order> placeOrder(String uid) async {
    // TODO: This should pull all the data from the shopping cart
    await _delay();
    final items = await getItemsList(uid);
    // First, make sure all items are available
    for (var item in items) {
      final product = _getProduct(item.productId);
      if (product.availableQuantity < item.quantity) {
        throw AssertionError(
            'Can\'t purchase ${item.quantity} quantity of $product');
      }
    }
    // then, place the order
    final userOrders = ordersData[uid] ?? [];
    final total = _totalPrice(items);
    final order = Order(
      id: const Uuid().v1(),
      userId: uid,
      items: items,
      // TODO: Update with real payment status
      // paymentStatus: PaymentStatus.paid,
      orderStatus: OrderStatus.confirmed,
      orderDate: DateTime.now(),
      total: total,
    );
    userOrders.add(order);
    ordersData[uid] = userOrders;
    _ordersDataSubject.add(ordersData);
    // and update all the product quantities
    for (var item in items) {
      final product = _getProduct(item.productId);
      final updated = product.copyWith(
          availableQuantity: product.availableQuantity - item.quantity);
      await editProduct(updated);
    }
    await _removeAllItems(uid);
    return order;
  }

  @override
  Future<void> updateOrderStatus(Order order) async {
    await _delay();
    final userOrders = ordersData[order.userId] ?? [];
    // TODO: Do this at the call site?
    final index = userOrders.indexWhere((element) => element.id == order.id);
    if (index >= 0) {
      userOrders[index] = order;
      ordersData[order.userId] = userOrders;
      // Note: Adding this to the stream causes additional rebuilds in the OrderList
      _ordersDataSubject.add(ordersData);
    } else {
      throw AssertionError('Order with id ${order.id} does not exist');
    }
  }

  @override
  Stream<List<Order>> allOrders() {
    return _ordersDataStream.map((ordersData) {
      final orders = <Order>[];
      for (var userOrders in ordersData.values) {
        orders.addAll(userOrders);
      }
      orders.sort(
        (lhs, rhs) => rhs.orderDate.compareTo(lhs.orderDate),
      );
      return orders;
    });
  }

  /// Throws error if not found
  Product _getProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  // -------------------------------------
  // Shopping cart
  // -------------------------------------

  Map<String, List<Item>> cartData = {};
  final _cartDataSubject = BehaviorSubject<Map<String, List<Item>>>.seeded({});
  Stream<Map<String, List<Item>>> get _cartDataStream =>
      _cartDataSubject.stream;

  @override
  Future<List<Item>> getItemsList(String uid) {
    return Future.value(cartData[uid] ?? []);
  }

  @override
  Stream<List<Item>> itemsList(String uid) {
    return _cartDataStream.map((cartData) {
      return cartData[uid] ?? [];
    });
  }

  @override
  Future<void> addItem(String uid, Item item) async {
    await _delay();
    final cart = MockCart(cartData[uid] ?? []);
    cart.addItem(item);
    cartData[uid] = cart.items;
    _cartDataSubject.add(cartData);
  }

  @override
  Future<void> removeItem(String uid, Item item) async {
    await _delay();
    final cart = MockCart(cartData[uid] ?? []);
    cart.removeItem(item);
    cartData[uid] = cart.items;
    _cartDataSubject.add(cartData);
  }

  @override
  Future<void> updateItemIfExists(String uid, Item item) async {
    await _delay(300);
    final cart = MockCart(cartData[uid] ?? []);
    final result = cart.updateItemIfExists(item);
    if (result) {
      cartData[uid] = cart.items;
      _cartDataSubject.add(cartData);
    }
  }

  @override
  Stream<CartTotal> cartTotal(String uid) {
    return _cartDataStream.map((cartData) {
      final items = cartData[uid] ?? [];
      final total = _totalPrice(items);
      return CartTotal(total: total);
    });
  }

  // private methods

  Future<void> _removeAllItems(String uid) async {
    await _delay();
    cartData[uid] = [];
    _cartDataSubject.add(cartData);
  }

  double _totalPrice(List<Item> items) => items.isEmpty
      ? 0.0
      : items
          // first extract quantity * price for each item
          .map((item) => item.quantity * _getProduct(item.productId).price)
          // then add them up
          .reduce((value, element) => value + element);

  Future<void> _delay([int milliseconds = 2000]) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
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
