import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/mutable_cart.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/fake_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/in_memory_store.dart';

class FakeLocalCartRepository implements LocalCartRepository {
  FakeLocalCartRepository(
      {required this.productsRepository, this.addDelay = true});
  final FakeProductsRepository productsRepository;
  final bool addDelay;

  final _cart = InMemoryStore<List<Item>>([]);

  @override
  Future<List<Item>> fetchItemsList() {
    return Future.value(_cart.value);
  }

  @override
  Stream<List<Item>> watchItemsList() => _cart.stream;

  @override
  Future<void> addItem(Item item) async {
    await delay(addDelay);
    final value = _cart.value;
    final cart = MutableCart(value);
    cart.addItem(item);
    _cart.value = cart.items;
  }

  @override
  Future<void> removeItem(Item item) async {
    await delay(addDelay);
    final value = _cart.value;
    final cart = MutableCart(value);
    cart.removeItem(item);
    _cart.value = cart.items;
  }

  @override
  Future<void> updateItemIfExists(Item item) async {
    await delay(addDelay, 300);
    final value = _cart.value;
    final cart = MutableCart(value);
    final result = cart.updateItemIfExists(item);
    if (result) {
      _cart.value = cart.items;
    }
  }

  @override
  Future<void> clear() async {
    await delay(addDelay);
    _cart.value = [];
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
