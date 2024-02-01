import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/mutable_cart.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/fake_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/in_memory_store.dart';

class FakeCartRepository implements CartRepository {
  FakeCartRepository({required this.productsRepository, this.addDelay = true});
  final FakeProductsRepository productsRepository;
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
  Future<void> addItem(String uid, Item item) async {
    await delay(addDelay);
    final value = _cart.value;
    final cart = MutableCart(value[uid] ?? []);
    cart.addItem(item);
    value[uid] = cart.items;
    _cart.value = value;
  }

  @override
  Future<void> removeItem(String uid, Item item) async {
    await delay(addDelay);
    final value = _cart.value;
    final cart = MutableCart(value[uid] ?? []);
    cart.removeItem(item);
    value[uid] = cart.items;
    _cart.value = value;
  }

  @override
  Future<void> updateItemIfExists(String uid, Item item) async {
    await delay(addDelay, 300);
    final value = _cart.value;
    final cart = MutableCart(value[uid] ?? []);
    final result = cart.updateItemIfExists(item);
    if (result) {
      value[uid] = cart.items;
      _cart.value = value;
    }
  }

  @override
  Future<void> addAllItems(String uid, List<Item> items) async {
    await delay(addDelay);
    final value = _cart.value;
    final cart = MutableCart(value[uid] ?? []);
    for (var item in items) {
      cart.addItem(item);
    }
    value[uid] = cart.items;
    _cart.value = value;
  }

  Future<void> removeAllItems(String uid) async {
    await delay(addDelay);
    final value = _cart.value;
    value[uid] = [];
    _cart.value = value;
  }

  double totalPrice(List<Item> items) => items.isEmpty
      ? 0.0
      : items
          // first extract quantity * price for each item
          .map((item) =>
              item.quantity *
              productsRepository.getProduct(item.productId).price)
          // then add them up
          .reduce((value, element) => value + element);
}
