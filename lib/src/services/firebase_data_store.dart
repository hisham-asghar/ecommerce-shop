import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class FirestorePath {
  static String address(String uid) => 'users/$uid/private/address';
  static String products() => 'products';
  static String product(String id) => 'products/$id';
  static String cart(String uid) => 'users/$uid/public/cart'; // contains total
  static String cartItems(String uid) => 'users/$uid/cartItems';
  static String cartItem(String uid, String id) => 'users/$uid/cartItems/$id';
}

class FirebaseDataStore implements DataStore {
  final _firestore = FirebaseFirestore.instance;
  @override
  Address? getAddress(String uid) {
    throw UnimplementedError();
  }

  @override
  Stream<Address?> address(String uid) {
    final ref = _firestore.doc(FirestorePath.address(uid)).withConverter(
        fromFirestore: (doc, _) => Address.fromMap(doc.data()!),
        toFirestore: (Address address, options) => address.toMap());
    return ref.snapshots().map((snapshot) => snapshot.data());
  }

  @override
  Future<void> submitAddress(String uid, Address address) {
    return _firestore.doc(FirestorePath.address(uid)).set(address.toMap());
  }

  // -------------------------------------
  // Products
  // -------------------------------------

  @override
  Stream<List<Product>> productsList() {
    final ref = _firestore.collection(FirestorePath.products()).withConverter(
        fromFirestore: (doc, _) => Product.fromMap(doc.data()!, doc.id),
        toFirestore: (Product product, options) => product.toMap());
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  /// Throws error if not found
  @override
  Product getProduct(String id) {
    throw UnimplementedError();
  }

  @override
  Stream<Product> product(String id) {
    final ref = _firestore.doc(FirestorePath.product(id)).withConverter(
        fromFirestore: (doc, _) => Product.fromMap(doc.data()!, doc.id),
        toFirestore: (Product product, options) => product.toMap());
    return ref.snapshots().map((snapshot) => snapshot.data()!);
  }

  @override
  Future<void> addProduct(Product product) async {
    // TODO: Should this generate the ID?
    return _firestore
        .doc(FirestorePath.product(product.id))
        .set(product.toMap());
  }

  @override
  Future<void> editProduct(Product product) async {
    return _firestore
        .doc(FirestorePath.product(product.id))
        .set(product.toMap());
  }

  // -------------------------------------
  // Orders
  // -------------------------------------

  // TODO: Implement
  @override
  Map<String, Order> getOrders(String uid) {
    throw UnimplementedError();
  }

  @override
  Stream<Map<String, Order>> orders(String uid) {
    throw UnimplementedError();
  }

  @override
  Future<void> placeOrder(String uid, Order order) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateOrderStatus(Order order, OrderStatus status) async {
    throw UnimplementedError();
  }

  @override
  Stream<List<Order>> ordersByDate(String uid) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Order>> allOrdersByDate() {
    throw UnimplementedError();
  }

  // -------------------------------------
  // Shopping cart
  // -------------------------------------

  @override
  Future<List<Item>> getItemsList(String uid) async {
    final ref = _firestore
        .collection(FirestorePath.cartItems(uid))
        .withConverter(
            fromFirestore: (doc, _) => Item.fromMap(doc.data()!),
            toFirestore: (Item item, options) => item.toMap());
    final snapshot = await ref.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  @override
  Stream<List<Item>> itemsList(String uid) {
    final ref = _firestore
        .collection(FirestorePath.cartItems(uid))
        .withConverter(
            fromFirestore: (doc, _) => Item.fromMap(doc.data()!),
            toFirestore: (Item item, options) => item.toMap());
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  @override
  Future<void> addItem(String uid, Item item) {
    // TODO: Let firestore generate item ID?
    return _firestore
        .doc(FirestorePath.cartItem(uid, item.productId))
        .set(item.toMap());
  }

  @override
  Future<void> removeItem(String uid, Item item) async {
    return _firestore.doc(FirestorePath.cartItem(uid, item.productId)).delete();
  }

  @override
  Future<void> updateItemIfExists(String uid, Item item) async {
    return _firestore
        .doc(FirestorePath.cartItem(uid, item.productId))
        .set(item.toMap());
  }

  @override
  Future<void> removeAllItems(String uid) async {
    // https://firebase.google.com/docs/firestore/manage-data/delete-data
    //  If you need to delete entire collections, do so only from a trusted server environment.
    final collectionRef = _firestore.collection(FirestorePath.cartItems(uid));
    final docsSnapshot = await collectionRef.get();
    for (var snapshot in docsSnapshot.docs) {
      final docId = FirestorePath.cartItem(uid, snapshot.id);
      await _firestore.doc(docId).delete();
    }
  }
}
