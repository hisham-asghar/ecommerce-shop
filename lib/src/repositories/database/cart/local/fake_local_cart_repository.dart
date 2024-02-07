import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/in_memory_store.dart';

class FakeLocalCartRepository implements LocalCartRepository {
  FakeLocalCartRepository({this.addDelay = true});
  final bool addDelay;

  final _cart = InMemoryStore<List<Item>>([]);

  @override
  Future<List<Item>> fetchItemsList() {
    return Future.value(_cart.value);
  }

  @override
  Stream<List<Item>> watchItemsList() => _cart.stream;

  @override
  Future<void> setItemsList(List<Item> items) async {
    await delay(addDelay);
    _cart.value = items;
  }
}
