import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/remote/cart_repository.dart';

class FirebaseCartRepository implements CartRepository {
  FirebaseCartRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String cartPath(String uid) => 'users/$uid/private/cart';

  @override
  Future<Cart> fetchCart(String uid) async {
    final ref = _cartRef(uid);
    final snapshot = await ref.get();
    return snapshot.data() ?? const Cart();
  }

  @override
  Stream<Cart> watchCart(String uid) {
    final ref = _cartRef(uid);
    return ref.snapshots().map((snapshot) => snapshot.data() ?? const Cart());
  }

  @override
  Future<void> setCart(String uid, Cart cart) async {
    final ref = _cartRef(uid);
    await ref.set(cart);
  }

  DocumentReference<Cart> _cartRef(String uid) =>
      _firestore.doc(cartPath(uid)).withConverter(
            fromFirestore: (doc, _) => Cart.fromMap(doc.data()!),
            toFirestore: (Cart cart, options) => cart.toMap(),
          );
}
