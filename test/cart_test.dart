import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart_item.dart';

void main() {
  group('Cart methods', () {
    test('empty cart - add item', () {
      final cart = Cart();
      cart.addItem(CartItem(productId: '1', quantity: 1));
      expect(cart.state, [CartItem(productId: '1', quantity: 1)]);
    });
    test('non-empty cart - add new item', () {
      final cart = Cart();
      cart.addItem(CartItem(productId: '1', quantity: 1));
      cart.addItem(CartItem(productId: '2', quantity: 1));
      expect(cart.state, [
        CartItem(productId: '1', quantity: 1),
        CartItem(productId: '2', quantity: 1),
      ]);
    });
    test('non-empty cart - add existing item', () {
      final cart = Cart();
      cart.addItem(CartItem(productId: '1', quantity: 1));
      cart.addItem(CartItem(productId: '1', quantity: 1));
      expect(cart.state, [
        CartItem(productId: '1', quantity: 2),
      ]);
    });
  });
}
