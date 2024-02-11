import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart/add_to_cart_state.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/exceptions/app_exception.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

import '../../../../mocks.dart';
import '../../../../utils.dart';

void main() {
  final localizations = AppLocalizationsEn();
  group('addItem', () {
    test('item added with quantity = 2, success', () async {
      const quantity = 2;
      final item = Item(productId: '1', quantity: quantity);
      final cartService = MockCartService();
      when(() => cartService.addItem(item))
          .thenAnswer((_) => Future.value(const Success(null)));
      final controller = AddToCartController(
        localizations: localizations,
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
      when(() => cartService.addItem(item)).thenAnswer(
          (_) => Future.value(const Error(AppException.permissionDenied(''))));
      final controller = AddToCartController(
        localizations: localizations,
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
          widgetState: VoidAsyncValue.error(localizations.cantAddItemToCart),
        ),
      );
    });
  });
}
