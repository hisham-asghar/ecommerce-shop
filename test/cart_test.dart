import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';

void main() {
  group('add item', () {
    test('empty cart - add item', () {
      final cart = Cart();
      cart.addItem(Item(productId: '1', quantity: 1));
      expect(cart.state, [Item(productId: '1', quantity: 1)]);
    });
    test('non-empty cart - add new item', () {
      final cart = Cart();
      cart.addItem(Item(productId: '1', quantity: 1));
      cart.addItem(Item(productId: '2', quantity: 1));
      expect(cart.state, [
        Item(productId: '1', quantity: 1),
        Item(productId: '2', quantity: 1),
      ]);
    });
    test('non-empty cart - add existing item', () {
      final cart = Cart();
      cart.addItem(Item(productId: '1', quantity: 1));
      cart.addItem(Item(productId: '1', quantity: 1));
      expect(cart.state, [
        Item(productId: '1', quantity: 2),
      ]);
    });
  });
  group('remove item', () {
    test('empty cart - remove item', () {
      final cart = Cart();
      cart.removeItem(Item(productId: '1', quantity: 1));
      expect(cart.state, []);
    });
    test('empty cart - remove matching item', () {
      final cart = Cart();
      cart.addItem(Item(productId: '1', quantity: 1));
      cart.removeItem(Item(productId: '1', quantity: 1));
      expect(cart.state, []);
    });
    test('empty cart - remove non-matching item', () {
      final cart = Cart();
      cart.addItem(Item(productId: '2', quantity: 1));
      cart.removeItem(Item(productId: '1', quantity: 1));
      expect(cart.state, [Item(productId: '2', quantity: 1)]);
    });
  });

  group('update quantity', () {
    test('empty cart - update quantity', () {
      final cart = Cart();
      cart.updateItemIfExists(Item(productId: '1', quantity: 2));
      expect(cart.state, []);
    });
    test('empty cart - update quantity matching item', () {
      final cart = Cart();
      cart.addItem(Item(productId: '1', quantity: 1));
      cart.updateItemIfExists(Item(productId: '1', quantity: 2));
      expect(cart.state, [Item(productId: '1', quantity: 2)]);
    });
    test('empty cart - update quantity non-matching item', () {
      final cart = Cart();
      cart.addItem(Item(productId: '2', quantity: 1));
      cart.updateItemIfExists(Item(productId: '1', quantity: 2));
      expect(cart.state, [Item(productId: '2', quantity: 1)]);
    });
  });
}
