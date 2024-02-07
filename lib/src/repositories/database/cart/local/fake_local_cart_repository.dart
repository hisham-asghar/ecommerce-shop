import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/in_memory_store.dart';

class FakeLocalCartRepository implements LocalCartRepository {
  FakeLocalCartRepository({this.addDelay = true});
  final bool addDelay;

  final _cart = InMemoryStore<Cart>(Cart({}));

  @override
  Future<Cart> fetchCart() {
    return Future.value(_cart.value);
  }

  @override
  Stream<Cart> watchCart() => _cart.stream;

  @override
  Future<void> setCart(Cart cart) async {
    await delay(addDelay);
    _cart.value = cart;
  }
}
