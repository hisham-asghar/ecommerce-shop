import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_total.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/fake_cart.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/delay.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/fake_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:rxdart/rxdart.dart';

class FakeLocalCartRepository implements LocalCartRepository {
  FakeLocalCartRepository(
      {required this.productsRepository, this.addDelay = true});
  final FakeProductsRepository productsRepository;
  final bool addDelay;

  List<Item> cartData = [];
  final _cartDataSubject = BehaviorSubject<List<Item>>.seeded([]);
  Stream<List<Item>> get _cartDataStream => _cartDataSubject.stream;

  @override
  Future<List<Item>> getItemsList() {
    return Future.value(cartData);
  }

  @override
  Stream<List<Item>> itemsList() => _cartDataStream;

  @override
  Future<void> addItem(Item item) async {
    await delay(addDelay);
    final cart = FakeCart(cartData);
    cart.addItem(item);
    cartData = cart.items;
    _cartDataSubject.add(cartData);
  }

  @override
  Future<void> removeItem(Item item) async {
    await delay(addDelay);
    final cart = FakeCart(cartData);
    cart.removeItem(item);
    cartData = cart.items;
    _cartDataSubject.add(cartData);
  }

  @override
  Future<void> updateItemIfExists(Item item) async {
    await delay(addDelay, 300);
    final cart = FakeCart(cartData);
    final result = cart.updateItemIfExists(item);
    if (result) {
      cartData = cart.items;
      _cartDataSubject.add(cartData);
    }
  }

  @override
  Stream<CartTotal> cartTotal(List<Product> products) {
    return _cartDataStream.map((cartData) {
      final items = cartData;
      final total = totalPrice(items);
      return CartTotal(total: total);
    });
  }

  @override
  Future<void> clear() async {
    await delay(addDelay);
    cartData = [];
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
