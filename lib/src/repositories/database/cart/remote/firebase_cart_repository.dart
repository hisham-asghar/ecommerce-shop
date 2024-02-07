import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/items_list.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/remote/cart_repository.dart';

class FirebaseCartRepository implements CartRepository {
  FirebaseCartRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String cartPath(String uid) => 'users/$uid/private/cart';

  @override
  Future<List<Item>> fetchItemsList(String uid) async {
    final ref = _cartItemsRef(uid);
    final snapshot = await ref.get();
    return snapshot.data()?.items ?? [];
  }

  @override
  Stream<List<Item>> watchItemsList(String uid) {
    final ref = _cartItemsRef(uid);
    return ref.snapshots().map((snapshot) => snapshot.data()?.items ?? []);
  }

  @override
  Future<void> setItemsList(String uid, List<Item> items) async {
    final ref = _cartItemsRef(uid);
    await ref.set(ItemsList(items));
  }

  DocumentReference<ItemsList> _cartItemsRef(String uid) =>
      _firestore.doc(cartPath(uid)).withConverter(
            fromFirestore: (doc, _) => ItemsList.fromMap(doc.data()!),
            toFirestore: (ItemsList items, options) => items.toMap(),
          );
}
