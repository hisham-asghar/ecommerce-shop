import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_state.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

import '../../../../mocks.dart';
import '../../../../utils.dart';

void main() {
  group('addItem', () {
    test('item added with quantity = 2, success', () async {
      const quantity = 2;
      final item = Item(productId: '1', quantity: quantity);
      final cartService = MockCartService();
      when(() => cartService.addItem(item)).thenAnswer((_) => Future.value());
      final controller = AddToCartController(
        cartService: cartService,
        product: makeProduct(id: '1', availableQuantity: 5),
      );
      expect(
        controller.debugState,
        AddToCartState(
          quantity: 1,
          widgetState: const VoidAsyncValue.data(null),
        ),
      );
      controller.updateQuantity(quantity);
      expect(
        controller.debugState,
        AddToCartState(
          quantity: 2,
          widgetState: const VoidAsyncValue.data(null),
        ),
      );
      await controller.addItem();
      verify(() => cartService.addItem(item)).called(1);
      // check that quantity goes back to 1 after adding an item
      expect(
        controller.debugState,
        AddToCartState(
          quantity: 1,
          widgetState: const VoidAsyncValue.data(null),
        ),
      );
    });

    test('item added with quantity = 2, failure', () async {
      const quantity = 2;
      final item = Item(productId: '1', quantity: quantity);
      final cartService = MockCartService();
      when(() => cartService.addItem(item))
          .thenAnswer((_) => throw StateError('could not add item'));
      final controller = AddToCartController(
        cartService: cartService,
        product: makeProduct(id: '1', availableQuantity: 5),
      );
      expect(
        controller.debugState,
        AddToCartState(
          quantity: 1,
          widgetState: const VoidAsyncValue.data(null),
        ),
      );
      controller.updateQuantity(quantity);
      expect(
        controller.debugState,
        AddToCartState(
          quantity: 2,
          widgetState: const VoidAsyncValue.data(null),
        ),
      );
      await controller.addItem();
      verify(() => cartService.addItem(item)).called(1);
      // check that quantity does not change after adding an item
      expect(
        controller.debugState,
        AddToCartState(
          quantity: 2,
          widgetState: const VoidAsyncValue.data(null),
        ),
      );
    });
  });
}
