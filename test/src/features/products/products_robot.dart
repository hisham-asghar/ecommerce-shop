import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/presentation/products_list/product_card.dart';

class ProductsRobot {
  ProductsRobot(this.tester);
  final WidgetTester tester;

  // products list
  Future<void> selectProduct({int atIndex = 0}) async {
    final finder = find.byKey(ProductCard.productCardKey);
    await tester.tap(finder.at(atIndex));
    await tester.pumpAndSettle();
  }

  void expectFindNProductCards(int count) {
    final finder = find.byType(ProductCard);
    expect(finder, findsNWidgets(count));
  }

  // product page
  Future<void> setProductQuantity(int quantity) async {
    final finder = find.byIcon(Icons.add);
    expect(finder, findsOneWidget);
    for (var i = 1; i < quantity; i++) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }

  Future<void> showMenu() async {
    final finder = find.bySemanticsLabel('Show menu');
    final matches = finder.evaluate();
    // if an item is found, it means that we're running on mobile and can tap
    // to reveal the menu
    if (matches.isNotEmpty) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
    // else no-op, as the items are already visible
  }
}
