import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_assets.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_state.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

class MockCartService extends Mock implements CartService {}

Product makeProduct(String id, int quantity) => Product(
      id: id,
      imageUrl: AppAssets.sonyPlaystation4,
      title: 'Sony Playstation 4 Pro White Version',
      description: '1234',
      price: 399,
      availableQuantity: quantity,
    );

void main() {
  group('getAvailableQuantity', () {
    test('item not in cart', () async {
      final cartService = MockCartService();
      final controller = AddToCartController(
        cartService: cartService,
        product: makeProduct('1', 5),
      );
      final cartItems = <Item>[];
      expect(controller.getAvailableQuantity(cartItems), 5);
    });
    test('item in cart with quantity = 1', () async {
      final cartService = MockCartService();
      final controller = AddToCartController(
        cartService: cartService,
        product: makeProduct('1', 5),
      );
      final cartItems = [
        Item(
          productId: '1',
          quantity: 1,
        ),
      ];
      expect(controller.getAvailableQuantity(cartItems), 4);
    });
    test('item in cart with quantity = max', () async {
      final cartService = MockCartService();
      final controller = AddToCartController(
        cartService: cartService,
        product: makeProduct('1', 5),
      );
      final cartItems = [
        Item(
          productId: '1',
          quantity: 5,
        ),
      ];
      expect(controller.getAvailableQuantity(cartItems), 0);
    });
    test('item in cart with quantity > max', () async {
      final cartService = MockCartService();
      final controller = AddToCartController(
        cartService: cartService,
        product: makeProduct('1', 5),
      );
      final cartItems = [
        Item(
          productId: '1',
          quantity: 6,
        ),
      ];
      expect(controller.getAvailableQuantity(cartItems), 0);
    });
  });

  group('addItem', () {
    test('item added with quantity = 2, success', () async {
      const quantity = 2;
      final item = Item(productId: '1', quantity: quantity);
      final cartService = MockCartService();
      when(() => cartService.addItem(item)).thenAnswer((_) => Future.value());
      final controller = AddToCartController(
        cartService: cartService,
        product: makeProduct('1', 5),
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
        product: makeProduct('1', 5),
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
