import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/items_list.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/mutable_cart.dart';

class FirebaseCartRepository implements CartRepository {
  FirebaseCartRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String cartPath(String uid) => 'users/$uid/private/cart';

  @override
  Future<List<Item>> getItemsList(String uid) async {
    final ref = _cartItemsRef(uid);
    final snapshot = await ref.get();
    return snapshot.data()?.items ?? [];
  }

  @override
  Stream<List<Item>> itemsList(String uid) {
    final ref = _cartItemsRef(uid);
    return ref.snapshots().map((snapshot) => snapshot.data()?.items ?? []);
  }

  @override
  Future<void> addItem(String uid, Item item) async {
    final itemsList = await getItemsList(uid);
    final cart = MutableCart(itemsList);
    cart.addItem(item);
    await _cartItemsRef(uid).set(ItemsList(cart.items));
  }

  @override
  Future<void> removeItem(String uid, Item item) async {
    final itemsList = await getItemsList(uid);
    final cart = MutableCart(itemsList);
    cart.removeItem(item);
    await _cartItemsRef(uid).set(ItemsList(cart.items));
  }

  @override
  Future<void> updateItemIfExists(String uid, Item item) async {
    final itemsList = await getItemsList(uid);
    final cart = MutableCart(itemsList);
    cart.updateItemIfExists(item);
    await _cartItemsRef(uid).set(ItemsList(cart.items));
  }

  @override
  Future<void> addAllItems(String uid, List<Item> items) async {
    final itemsList = await getItemsList(uid);
    final cart = MutableCart(itemsList);
    for (var item in items) {
      cart.addItem(item);
    }
    await _cartItemsRef(uid).set(ItemsList(cart.items));
  }

  DocumentReference<ItemsList> _cartItemsRef(String uid) =>
      _firestore.doc(cartPath(uid)).withConverter(
            fromFirestore: (doc, _) => ItemsList.fromMap(doc.data()!),
            toFirestore: (ItemsList items, options) => items.toMap(),
          );
}
