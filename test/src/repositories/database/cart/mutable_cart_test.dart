import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/services/mutable_cart.dart';

void main() {
  group('add item', () {
    test('empty cart - add item', () {
      final cart = const Cart().addItem(Item(productId: '1', quantity: 1));
      expect(cart.items, {'1': 1});
    });
    test('non-empty cart - add new item', () {
      final cart = const Cart()
          .addItem(Item(productId: '1', quantity: 1))
          .addItem(Item(productId: '2', quantity: 1));
      expect(cart.items, {
        '1': 1,
        '2': 1,
      });
    });
    test('non-empty cart - add existing item', () {
      final cart = const Cart()
          .addItem(Item(productId: '1', quantity: 1))
          .addItem(Item(productId: '1', quantity: 1));
      expect(cart.items, {'1': 2});
    });
  });
  group('remove item', () {
    test('empty cart - remove item', () {
      final cart = const Cart().removeItem(Item(productId: '1', quantity: 1));
      expect(cart.items, {});
    });
    test('empty cart - remove matching item', () {
      final cart = const Cart()
          .addItem(Item(productId: '1', quantity: 1))
          .removeItem(Item(productId: '1', quantity: 1));
      expect(cart.items, {});
    });
    test('empty cart - remove non-matching item', () {
      final cart = const Cart()
          .addItem(Item(productId: '2', quantity: 1))
          .removeItem(Item(productId: '1', quantity: 1));
      expect(cart.items, {'2': 1});
    });
  });

  group('remove all items', () {
    test('some items - all', () {
      final cart = const Cart()
          .addItem(Item(productId: '1', quantity: 1))
          .addItem(Item(productId: '2', quantity: 2))
          .clear();
      expect(cart.items, {});
    });
  });

  group('update quantity', () {
    test('empty cart - update quantity', () {
      final cart =
          const Cart().updateItemIfExists(Item(productId: '1', quantity: 2));
      expect(cart.items, {});
    });
    test('empty cart - update quantity matching item', () {
      final cart = const Cart()
          .addItem(Item(productId: '1', quantity: 1))
          .updateItemIfExists(Item(productId: '1', quantity: 2));
      expect(cart.items, {'1': 2});
    });
    test('empty cart - update quantity non-matching item', () {
      final cart = const Cart()
          .addItem(Item(productId: '2', quantity: 1))
          .updateItemIfExists(Item(productId: '1', quantity: 2));
      expect(cart.items, {'2': 1});
    });
  });
}
