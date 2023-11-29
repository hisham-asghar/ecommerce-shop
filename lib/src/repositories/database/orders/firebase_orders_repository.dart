import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/orders_repository.dart';

class FirebaseOrdersRepository implements OrdersRepository {
  FirebaseOrdersRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String userOrdersPath(String uid) => 'users/$uid/orders';
  static String userOrderPath(String uid, String id) => 'users/$uid/orders/$id';
  static String adminOrdersPath() => 'orders';
  static String adminOrderPath(String id) => 'orders/$id';

  @override
  Stream<Order> userOrder(String uid, String orderId) {
    final ref = _userOrderRef(uid, orderId);
    return ref.snapshots().map((snapshot) => snapshot.data()!);
  }

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
      .collection(userOrdersPath(uid))
      .orderBy('orderDate', descending: true)
      .withConverter(
        fromFirestore: (doc, _) => Order.fromMap(doc.data()!, doc.id),
        toFirestore: (Order order, options) => order.toMap(),
      );

  DocumentReference<Order> _userOrderRef(String uid, String orderId) =>
      _firestore.doc(userOrderPath(uid, orderId)).withConverter(
            fromFirestore: (doc, _) => Order.fromMap(doc.data()!, orderId),
            toFirestore: (Order order, options) => order.toMap(),
          );

  Query<Order> _adminOrdersRef() => _firestore
      .collection(adminOrdersPath())
      .orderBy('orderDate', descending: true)
      .withConverter(
        fromFirestore: (doc, _) => Order.fromMap(doc.data()!, doc.id),
        toFirestore: (Order order, options) => order.toMap(),
      );

  DocumentReference<Order> _adminOrderRef(String orderId) =>
      _firestore.doc(adminOrderPath(orderId)).withConverter(
            fromFirestore: (doc, _) => Order.fromMap(doc.data()!, orderId),
            toFirestore: (Order order, options) => order.toMap(),
          );
}
