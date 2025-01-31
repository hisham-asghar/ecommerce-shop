import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import '../../../../../robot.dart';

void main() {
  // https://stackoverflow.com/a/57998506/436422
  setUpAll(() => HttpOverrides.global = null);

  group('shopping cart', () {
    testWidgets('Given no products Then product list is empty', (tester) async {
      final r = Robot(tester);
      await r.pumpWidgetAppWithMocks(initTestProducts: false);
      r.products.expectFindNProductCards(0);
    });

    testWidgets('Given default products Then product list has 14 items',
        (tester) async {
      final r = Robot(tester);
      await r.pumpWidgetAppWithMocks(initTestProducts: true);
      r.products.expectFindNProductCards(14);
    });

    testWidgets('Given no items added When open cart Then cart is empty',
        (tester) async {
      final r = Robot(tester);
      await r.pumpWidgetAppWithMocks();
      await r.cart.openCart();
      r.cart.expectShoppingCartIsEmpty();
    });

    testWidgets(
        'Given add item with quantity = 1 When open cart Then cart contains item with quantity = 1',
        (tester) async {
      final r = Robot(tester);
      await r.pumpWidgetAppWithMocks();
      await r.products.selectProduct();
      await r.cart.addToCart();
      await r.cart.openCart();
      r.cart.expectItemQuantity(quantity: 1, atIndex: 0);
    });

    testWidgets(
        'Given add item with quantity = 5 When open cart Then cart contains item with quantity = 5',
        (tester) async {
      final r = Robot(tester);
      await r.pumpWidgetAppWithMocks();
      await r.products.selectProduct();
      await r.products.setProductQuantity(5);
      await r.cart.addToCart();
      await r.cart.openCart();
      r.cart.expectItemQuantity(quantity: 5, atIndex: 0);
    });

    testWidgets(
        'Given add item with quantity = 6 When open cart Then cart contains item with quantity = 5',
        (tester) async {
      final r = Robot(tester);
      await r.pumpWidgetAppWithMocks();
      await r.products.selectProduct();
      await r.products.setProductQuantity(6);
      await r.cart.addToCart();
      await r.cart.openCart();
      r.cart.expectItemQuantity(quantity: 5, atIndex: 0);
    });

    testWidgets(
        'Given add item with quantity = 2 When open cart And increment by 2 Then cart contains item with quantity = 4',
        (tester) async {
      final r = Robot(tester);
      await r.pumpWidgetAppWithMocks();
      await r.products.selectProduct();
      await r.products.setProductQuantity(2);
      await r.cart.addToCart();
      await r.cart.openCart();
      await r.cart.incrementCartItemQuantity(quantity: 2, atIndex: 0);
      r.cart.expectItemQuantity(quantity: 4, atIndex: 0);
    });

    testWidgets(
        'Given add item with quantity = 5 When open cart And decrement by 2 Then cart contains item with quantity = 3',
        (tester) async {
      final r = Robot(tester);
      await r.pumpWidgetAppWithMocks();
      await r.products.selectProduct();
      await r.products.setProductQuantity(5);
      await r.cart.addToCart();
      await r.cart.openCart();
      await r.cart.decrementCartItemQuantity(quantity: 2, atIndex: 0);
      r.cart.expectItemQuantity(quantity: 3, atIndex: 0);
    });

    testWidgets('Given add two items Then cart contains two items',
        (tester) async {
      final r = Robot(tester);
      await r.pumpWidgetAppWithMocks();
      // add first product
      await r.products.selectProduct(atIndex: 0);
      await r.cart.addToCart();
      await r.goBack();
      // add second product
      await r.products.selectProduct(atIndex: 1);
      await r.cart.addToCart();
      await r.cart.openCart();
      r.cart.expectFindNCartItems(2);
    });

    testWidgets(
        'Given add item When open cart And item is deleted Then cart is empty',
        (tester) async {
      final r = Robot(tester);
      await r.pumpWidgetAppWithMocks();
      await r.products.selectProduct();
      await r.cart.addToCart();
      await r.cart.openCart();
      await r.cart.deleteCartItem(atIndex: 0);
      r.cart.expectShoppingCartIsEmpty();
    });

    testWidgets('Given add item with quantity = 5 Then item is out of stock',
        (tester) async {
      final r = Robot(tester);
      await r.pumpWidgetAppWithMocks();
      await r.products.selectProduct();
      await r.products.setProductQuantity(5);
      await r.cart.addToCart();
      r.cart.expectProductIsOutOfStock();
    });

    testWidgets(
        'Given add item with quantity = 5 When navigate back in Then item is out of stock',
        (tester) async {
      final r = Robot(tester);
      await r.pumpWidgetAppWithMocks();
      await r.products.selectProduct();
      await r.products.setProductQuantity(5);
      await r.cart.addToCart();
      await r.goBack();
      await r.products.selectProduct();
      r.cart.expectProductIsOutOfStock();
    });
  });
}
