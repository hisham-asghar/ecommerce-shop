import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/mutable_cart.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/fake_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';
import 'package:rxdart/rxdart.dart';

class FakeCartRepository implements CartRepository {
  FakeCartRepository({required this.productsRepository, this.addDelay = true});
  final FakeProductsRepository productsRepository;
  final bool addDelay;

  Map<String, List<Item>> cartData = {};
  final _cartDataSubject = BehaviorSubject<Map<String, List<Item>>>.seeded({});
  Stream<Map<String, List<Item>>> get _cartDataStream =>
      _cartDataSubject.stream;

  @override
  Future<List<Item>> getItemsList(String uid) {
    return Future.value(cartData[uid] ?? []);
  }

  @override
  Stream<List<Item>> itemsList(String uid) {
    return _cartDataStream.map((cartData) {
      return cartData[uid] ?? [];
    });
  }

  @override
  Future<void> addItem(String uid, Item item) async {
    await delay(addDelay);
    final cart = MutableCart(cartData[uid] ?? []);
    cart.addItem(item);
    cartData[uid] = cart.items;
    _cartDataSubject.add(cartData);
  }

  @override
  Future<void> removeItem(String uid, Item item) async {
    await delay(addDelay);
    final cart = MutableCart(cartData[uid] ?? []);
    cart.removeItem(item);
    cartData[uid] = cart.items;
    _cartDataSubject.add(cartData);
  }

  @override
  Future<void> updateItemIfExists(String uid, Item item) async {
    await delay(addDelay, 300);
    final cart = MutableCart(cartData[uid] ?? []);
    final result = cart.updateItemIfExists(item);
    if (result) {
      cartData[uid] = cart.items;
      _cartDataSubject.add(cartData);
    }
  }

  @override
  Future<void> addAllItems(String uid, List<Item> items) async {
    await delay(addDelay);
    final cart = MutableCart(cartData[uid] ?? []);
    for (var item in items) {
      cart.addItem(item);
    }
    cartData[uid] = cart.items;
    _cartDataSubject.add(cartData);
  }

  Future<void> removeAllItems(String uid) async {
    await delay(addDelay);
    cartData[uid] = [];
    _cartDataSubject.add(cartData);
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
