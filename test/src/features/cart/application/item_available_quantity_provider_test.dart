import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/application/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/cart.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../utils.dart';

// class Listener<T> extends Mock {
//   void call(T? previous, T? next);
// }

void main() {
  group('itemAvailableQuantityProvider', () {
    test('item not in cart', () async {
      final product = makeProduct(id: '1', availableQuantity: 5);
      final container = ProviderContainer(
        overrides: [
          cartProvider.overrideWithValue(const AsyncValue.data(Cart()))
        ],
      );
      addTearDown(container.dispose);
      final provider = itemAvailableQuantityProvider(product);
      // final listener = Listener<AsyncValue<int>>();
      // container.listen<AsyncValue<int>>(
      //   provider,
      //   listener,
      //   fireImmediately: true,
      // );
      // read container value (asynchronously)
      final value = await container.read(provider.future);
      expect(value, 5);

      // verify(
      //   () => listener(null, const AsyncValue.loading()),
      // ).called(1);
      // verify(
      //   () => listener(const AsyncValue.loading(), const AsyncValue.data(5)),
      // ).called(1);
      // verifyNoMoreInteractions(listener);
    });

    test('item in cart with quantity = 1', () async {
      final product = makeProduct(id: '1', availableQuantity: 5);
      final container = ProviderContainer(
        overrides: [
          cartProvider.overrideWithValue(const AsyncValue.data(Cart({'1': 1})))
        ],
      );
      addTearDown(container.dispose);
      final provider = itemAvailableQuantityProvider(product);
      // read container value (asynchronously)
      final value = await container.read(provider.future);
      expect(value, 4);
    });

    test('item in cart with quantity = max', () async {
      final product = makeProduct(id: '1', availableQuantity: 5);
      final container = ProviderContainer(
        overrides: [
          cartProvider.overrideWithValue(const AsyncValue.data(Cart({'1': 5})))
        ],
      );
      addTearDown(container.dispose);
      final provider = itemAvailableQuantityProvider(product);
      // read container value (asynchronously)
      final value = await container.read(provider.future);
      expect(value, 0);
    });
    test('item in cart with quantity > max', () async {
      final product = makeProduct(id: '1', availableQuantity: 5);
      final container = ProviderContainer(
        overrides: [
          cartProvider.overrideWithValue(const AsyncValue.data(Cart({'1': 6})))
        ],
      );
      addTearDown(container.dispose);
      final provider = itemAvailableQuantityProvider(product);
      // read container value (asynchronously)
      final value = await container.read(provider.future);
      expect(value, 0);
    });
  });
}
