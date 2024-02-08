import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/orders_repository.dart';

class FirebaseOrdersRepository implements OrdersRepository {
  FirebaseOrdersRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String ordersPath() => 'orders';
  static String userOrderPath(String uid, String id) => 'users/$uid/orders/$id';

  @override
  Stream<List<Order>> watchUserOrders(String uid) {
    final ref = _userOrdersRef(uid);
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  @override
  Future<void> updateOrderStatus(Order order) async {
    final ref = _userOrderRef(order.userId, order.id);
    return ref.set(order);
  }

  @override
  Stream<List<Order>> watchAllOrders() {
    final ref = _adminOrdersRef();
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  Query<Order> _userOrdersRef(String uid) => _firestore
      .collectionGroup(ordersPath())
      .where('userId', isEqualTo: uid)
      .orderBy('orderDate', descending: true)
      .withConverter(
        fromFirestore: (doc, _) => Order.fromMap(doc.data()!, doc.id),
        toFirestore: (Order order, options) => order.toMap(),
      );

  Query<Order> _adminOrdersRef() => _firestore
      .collectionGroup(ordersPath())
      // note: no where clause here
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
}
