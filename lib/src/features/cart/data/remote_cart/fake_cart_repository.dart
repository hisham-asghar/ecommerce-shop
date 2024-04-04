import 'package:my_shop_ecommerce_flutter/src/features/cart/data/remote_cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/delay.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/in_memory_store.dart';

class FakeCartRepository implements CartRepository {
  FakeCartRepository({this.addDelay = true});
  final bool addDelay;

  final _cart = InMemoryStore<Map<String, Cart>>({});

  @override
  Future<Cart> fetchCart(String uid) {
    return Future.value(_cart.value[uid] ?? const Cart());
  }

  @override
  Stream<Cart> watchCart(String uid) {
    return _cart.stream.map((cartData) {
      return cartData[uid] ?? const Cart();
    });
  }

  @override
  Future<void> setCart(String uid, Cart items) async {
    await delay(addDelay);
    // First, get the current cart data
    final value = _cart.value;
    // Then, set the items for the given uid
    value[uid] = items;
    // Finally, update the cart data (will emit a new value)
    _cart.value = value;
  }
}
