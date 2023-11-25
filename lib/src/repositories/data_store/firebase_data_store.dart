import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/cart_total.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/product.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/order.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/item.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/address.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/data_store/data_store.dart';

class FirestorePath {
  static String products() => 'products';
  static String product(String id) => 'products/$id';
  static String address(String uid) => 'users/$uid/private/address';
  static String cart(String uid) => 'users/$uid/private/cart'; // contains total
  static String cartItems(String uid) => 'users/$uid/cartItems';
  static String cartItem(String uid, String id) => 'users/$uid/cartItems/$id';
  static String userOrders(String uid) => 'users/$uid/orders';
  static String userOrder(String uid, String id) => 'users/$uid/orders/$id';
  static String adminOrders() => 'orders';
  static String adminOrder(String id) => 'orders/$id';
}

class FirebaseDataStore implements DataStore {
  final _firestore = FirebaseFirestore.instance;
  @override
  Future<Address?> getAddress(String uid) async {
    final ref = _addressRef(uid);
    final snapshot = await ref.get();
    return snapshot.data();
  }

  @override
  Stream<Address?> address(String uid) {
    final ref = _addressRef(uid);
    return ref.snapshots().map((snapshot) => snapshot.data());
  }

  @override
  Future<void> submitAddress(String uid, Address address) {
    return _addressRef(uid).set(address);
  }

  DocumentReference<Address> _addressRef(String uid) =>
      _firestore.doc(FirestorePath.address(uid)).withConverter(
            fromFirestore: (doc, _) => Address.fromMap(doc.data()!),
            toFirestore: (Address address, options) => address.toMap(),
          );

  // -------------------------------------
  // Products
  // -------------------------------------

  @override
  Stream<List<Product>> productsList() {
    final ref = _productsRef();
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  @override
  Stream<Product> product(String id) {
    final ref = _productRef(id);
    return ref.snapshots().map((snapshot) => snapshot.data()!);
  }

  @override
  Future<void> addProduct(Product product) async {
    final ref = _productsRef();
    await ref.add(product);
  }

  @override
  Future<void> editProduct(Product product) async {
    final ref = _productRef(product.id);
    return ref.set(product);
  }

  DocumentReference<Product> _productRef(String id) =>
      _firestore.doc(FirestorePath.product(id)).withConverter(
            fromFirestore: (doc, _) => Product.fromMap(doc.data()!, doc.id),
            toFirestore: (Product product, options) => product.toMap(),
          );

  CollectionReference<Product> _productsRef() =>
      _firestore.collection(FirestorePath.products()).withConverter(
            fromFirestore: (doc, _) => Product.fromMap(doc.data()!, doc.id),
            toFirestore: (Product product, options) => product.toMap(),
          );
  // -------------------------------------
  // Orders
  // -------------------------------------

  @override
  Stream<List<Order>> userOrders(String uid) {
    final ref = _userOrdersRef(uid);
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  @override
  Future<void> updateOrderStatus(Order order) async {
    final ref = _adminOrderRef(order.id);
    return ref.set(order);
  }

  @override
  Stream<List<Order>> allOrders() {
    final ref = _adminOrdersRef();
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  Query<Order> _userOrdersRef(String uid) => _firestore
      .collection(FirestorePath.userOrders(uid))
      .orderBy('orderDate', descending: true)
      .withConverter(
        fromFirestore: (doc, _) => Order.fromMap(doc.data()!, doc.id),
        toFirestore: (Order order, options) => order.toMap(),
      );

  Query<Order> _adminOrdersRef() => _firestore
      .collection(FirestorePath.adminOrders())
      .orderBy('orderDate', descending: true)
      .withConverter(
        fromFirestore: (doc, _) => Order.fromMap(doc.data()!, doc.id),
        toFirestore: (Order order, options) => order.toMap(),
      );

  DocumentReference<Order> _adminOrderRef(String orderId) =>
      _firestore.doc(FirestorePath.adminOrder(orderId)).withConverter(
            fromFirestore: (doc, _) => Order.fromMap(doc.data()!, orderId),
            toFirestore: (Order order, options) => order.toMap(),
          );
  // -------------------------------------
  // Shopping cart Items
  // -------------------------------------

  @override
  Future<List<Item>> getItemsList(String uid) async {
    final ref = _itemsListRef(uid);
    final snapshot = await ref.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  @override
  Stream<List<Item>> itemsList(String uid) {
    final ref = _itemsListRef(uid);
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  @override
  Future<void> addItem(String uid, Item item) async {
    final existingItem = await _getItem(uid, item.productId);
    final updatedQuantity = existingItem != null
        ? item.quantity + existingItem.quantity
        : item.quantity;
    final updatedItem = item.copyWith(quantity: updatedQuantity);
    return _firestore
        .doc(FirestorePath.cartItem(uid, updatedItem.productId))
        .set(updatedItem.toMap());
  }

  Future<Item?> _getItem(String uid, String productId) async {
    final ref = _itemRef(uid, productId);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return snapshot.data()!;
    } else {
      return null;
    }
  }

  @override
  Future<void> removeItem(String uid, Item item) async {
    final ref = _itemRef(uid, item.productId);
    return ref.delete();
  }

  @override
  Future<void> updateItemIfExists(String uid, Item item) async {
    final ref = _itemRef(uid, item.productId);
    return ref.set(item);
  }

  @override
  Future<void> addAllItems(String uid, List<Item> items) async {
    final ref = _itemsListRef(uid);
    for (var item in items) {
      await ref.add(item);
    }
  }

  CollectionReference<Item> _itemsListRef(String uid) =>
      _firestore.collection(FirestorePath.cartItems(uid)).withConverter(
            fromFirestore: (doc, _) => Item.fromMap(doc.data()!),
            toFirestore: (Item item, options) => item.toMap(),
          );

  DocumentReference<Item> _itemRef(String uid, String productId) =>
      _firestore.doc(FirestorePath.cartItem(uid, productId)).withConverter(
            fromFirestore: (doc, _) => Item.fromMap(doc.data()!),
            toFirestore: (Item item, options) => item.toMap(),
          );

  // -------------------------------------
  // Shopping cart total
  // -------------------------------------
  @override
  Stream<CartTotal> cartTotal(String uid) {
    return _cartTotalRef(uid)
        .snapshots()
        .map((snapshot) => snapshot.data() ?? CartTotal(total: 0));
  }

  DocumentReference<CartTotal> _cartTotalRef(String uid) =>
      _firestore.doc(FirestorePath.cart(uid)).withConverter(
            fromFirestore: (doc, _) => CartTotal.fromMap(doc.data()),
            toFirestore: (CartTotal cartTotal, options) => cartTotal.toMap(),
          );
}
