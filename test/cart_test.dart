import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart_item.dart';

void main() {
  group('add item', () {
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
  group('remove item', () {
    test('empty cart - remove item', () {
      final cart = Cart();
      cart.removeItem(CartItem(productId: '1', quantity: 1));
      expect(cart.state, []);
    });
    test('empty cart - remove matching item', () {
      final cart = Cart();
      cart.addItem(CartItem(productId: '1', quantity: 1));
      cart.removeItem(CartItem(productId: '1', quantity: 1));
      expect(cart.state, []);
    });
    test('empty cart - remove non-matching item', () {
      final cart = Cart();
      cart.addItem(CartItem(productId: '2', quantity: 1));
      cart.removeItem(CartItem(productId: '1', quantity: 1));
      expect(cart.state, [CartItem(productId: '2', quantity: 1)]);
    });
  });

  group('update quantity', () {
    test('empty cart - update quantity', () {
      final cart = Cart();
      cart.updateItemIfExists(CartItem(productId: '1', quantity: 2));
      expect(cart.state, []);
    });
    test('empty cart - update quantity matching item', () {
      final cart = Cart();
      cart.addItem(CartItem(productId: '1', quantity: 1));
      cart.updateItemIfExists(CartItem(productId: '1', quantity: 2));
      expect(cart.state, [CartItem(productId: '1', quantity: 2)]);
    });
    test('empty cart - update quantity non-matching item', () {
      final cart = Cart();
      cart.addItem(CartItem(productId: '2', quantity: 1));
      cart.updateItemIfExists(CartItem(productId: '1', quantity: 2));
      expect(cart.state, [CartItem(productId: '2', quantity: 1)]);
    });
  });
}
