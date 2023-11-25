import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_total.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';

class FirebaseCartRepository implements CartRepository {
  FirebaseCartRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String cartPath(String uid) =>
      'users/$uid/private/cart'; // contains total
  static String cartItemsPath(String uid) => 'users/$uid/cartItems';
  static String cartItemPath(String uid, String id) =>
      'users/$uid/cartItems/$id';

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
        .doc(cartItemPath(uid, updatedItem.productId))
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
      _firestore.collection(cartItemsPath(uid)).withConverter(
            fromFirestore: (doc, _) => Item.fromMap(doc.data()!),
            toFirestore: (Item item, options) => item.toMap(),
          );

  DocumentReference<Item> _itemRef(String uid, String productId) =>
      _firestore.doc(cartItemPath(uid, productId)).withConverter(
            fromFirestore: (doc, _) => Item.fromMap(doc.data()!),
            toFirestore: (Item item, options) => item.toMap(),
          );

  @override
  Stream<CartTotal> cartTotal(String uid) {
    return _cartTotalRef(uid)
        .snapshots()
        .map((snapshot) => snapshot.data() ?? CartTotal(total: 0));
  }

  DocumentReference<CartTotal> _cartTotalRef(String uid) =>
      _firestore.doc(cartPath(uid)).withConverter(
            fromFirestore: (doc, _) => CartTotal.fromMap(doc.data()),
            toFirestore: (CartTotal cartTotal, options) => cartTotal.toMap(),
          );
}
