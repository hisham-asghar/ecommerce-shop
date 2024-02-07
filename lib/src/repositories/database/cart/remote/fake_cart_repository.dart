import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/remote/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/in_memory_store.dart';

class FakeCartRepository implements CartRepository {
  FakeCartRepository({this.addDelay = true});
  final bool addDelay;

  final _cart = InMemoryStore<Map<String, List<Item>>>({});

  @override
  Future<List<Item>> fetchItemsList(String uid) {
    return Future.value(_cart.value[uid] ?? []);
  }

  @override
  Stream<List<Item>> watchItemsList(String uid) {
    return _cart.stream.map((cartData) {
      return cartData[uid] ?? [];
    });
  }

  @override
  Future<void> setItemsList(String uid, List<Item> items) async {
    await delay(addDelay);
    // First, get the current cart data
    final value = _cart.value;
    // Then, set the items for the given uid
    value[uid] = items;
    // Finally, update the cart data (will emit a new value)
    _cart.value = value;
  }
}
