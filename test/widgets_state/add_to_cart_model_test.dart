import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_assets.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_model.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_state.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class MockCartRepository extends Mock implements CartRepository {}

Product _makeFakeProduct() => Product(
      id: '1',
      imageUrl: AppAssets.sonyPlaystation4,
      title: 'Sony Playstation 4 Pro White Version',
      description: 'Something',
      price: 399,
      availableQuantity: 5,
    );

void main() {
  group('AddToCartModel - constructor', () {
    test('quantity: 1', () async {
      // setup
      final repository = MockCartRepository();
      final model = AddToCartModel(cartRepository: repository);
      // verify
      expect(
          model.state,
          AddToCartState(
            quantity: 1,
            widgetState: const WidgetBasicState.notLoading(),
          ));
    });
  });

  group('AddToCartModel - updateQuantity', () {
    test('success', () async {
      // setup
      final repository = MockCartRepository();
      final model = AddToCartModel(cartRepository: repository);
      model.updateQuantity(10);
      // verify
      expect(
          model.state,
          AddToCartState(
            quantity: 10,
            widgetState: const WidgetBasicState.notLoading(),
          ));
    });
  });

  group('AddToCartModel - addItem', () {
    test('success', () async {
      // setup
      final repository = MockCartRepository();
      // simulate success
      when(() => repository.addItem(Item(productId: '1', quantity: 1)))
          .thenAnswer((_) => Future<void>.value());
      final observedStates = <AddToCartState>[];
      final model = AddToCartModel(cartRepository: repository);
      // update quantity as part of the initial setup
      model.updateQuantity(2);
      // track all state chanegs
      model.addListener(observedStates.add);
      // run
      await model.addItem(_makeFakeProduct());

      // verify
      expect(observedStates, [
        // start with quantity: 2
        AddToCartState(
            quantity: 2, widgetState: const WidgetBasicState.notLoading()),
        AddToCartState(
            quantity: 2, widgetState: const WidgetBasicState.loading()),
        // back to quantity: 1 once item has been added to cart
        AddToCartState(
            quantity: 1, widgetState: const WidgetBasicState.notLoading()),
      ]);
    });

    test('failure', () async {
      // setup
      final repository = MockCartRepository();
      // simulate success
      when(() => repository.addItem(Item(productId: '1', quantity: 1)))
          .thenThrow(StateError('Database error'));
      final observedStates = <AddToCartState>[];
      final model = AddToCartModel(cartRepository: repository);
      // update quantity as part of the initial setup
      model.updateQuantity(2);
      // track all state chanegs
      model.addListener(observedStates.add);
      // run
      await model.addItem(_makeFakeProduct());

      // verify
      expect(observedStates, [
        // start with quantity: 2
        AddToCartState(
            quantity: 2, widgetState: const WidgetBasicState.notLoading()),
        AddToCartState(
            quantity: 2, widgetState: const WidgetBasicState.loading()),
        AddToCartState(
            quantity: 2,
            widgetState:
                const WidgetBasicState.error('Can\'t add item to cart')),
        // this time, the quantity does not change because the operation wasn't successful
        AddToCartState(
            quantity: 2, widgetState: const WidgetBasicState.notLoading()),
      ]);
    });
  });
}
