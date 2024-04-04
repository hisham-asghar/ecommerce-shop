import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/application/cart_sync_service.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/item.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/domain/product.dart';

import '../../../../mocks.dart';
import '../../../../utils.dart';

void main() {
  group('copyItemsToRemote', () {
    late MockCartRepository mockCartRepository;
    late MockLocalCartRepository mockLocalCartRepository;
    late MockProductsRepository mockProductsRepository;
    setUp(() {
      mockCartRepository = MockCartRepository();
      mockLocalCartRepository = MockLocalCartRepository();
      mockProductsRepository = MockProductsRepository();
      registerFallbackValue(<Item>[]);
    });

    CartSyncService makeCartService() => CartSyncService(
          cartRepository: mockCartRepository,
          localCartRepository: mockLocalCartRepository,
          productsRepository: mockProductsRepository,
        );

    Future<void> runCopyItemsToRemoteTest({
      required String uid,
      required List<Product> products,
      required Map<String, int> itemsToAdd,
      required Map<String, int> itemsInCart,
      required Map<String, int> expectedItemsInCart,
    }) async {
      when(() => mockLocalCartRepository.fetchCart())
          .thenAnswer((_) => Future.value(Cart(itemsToAdd)));
      when(() => mockProductsRepository.fetchProductsList())
          .thenAnswer((_) => Future.value(products));
      when(() => mockCartRepository.fetchCart(uid))
          .thenAnswer((_) => Future.value(Cart(itemsInCart)));
      when(() => mockCartRepository.setCart(uid, Cart(expectedItemsInCart)))
          .thenAnswer((_) => Future.value());
      when(() => mockLocalCartRepository.setCart(const Cart()))
          .thenAnswer((_) => Future.value());
      final cartService = makeCartService();
      // run
      await cartService.moveItemsToRemote(uid);
      // verify
      verify(() => mockCartRepository.setCart(uid, Cart(expectedItemsInCart)))
          .called(1);
    }

    test('local quantity <= available quantity', () async {
      await runCopyItemsToRemoteTest(
        uid: '123',
        products: [
          makeProduct(id: '1', availableQuantity: 10),
        ],
        itemsToAdd: {'1': 1},
        itemsInCart: {},
        expectedItemsInCart: {'1': 1},
      );
    });
    test('local quantity > available quantity', () async {
      await runCopyItemsToRemoteTest(
        uid: '123',
        products: [
          makeProduct(id: '1', availableQuantity: 10),
        ],
        itemsToAdd: {'1': 15},
        itemsInCart: {},
        expectedItemsInCart: {'1': 10},
      );
    });

    test('local + remote quantity <= available quantity', () async {
      await runCopyItemsToRemoteTest(
        uid: '123',
        products: [
          makeProduct(id: '1', availableQuantity: 10),
        ],
        itemsToAdd: {'1': 1},
        itemsInCart: {'1': 1},
        expectedItemsInCart: {'1': 2},
      );
    });

    test('local + remote quantity > available quantity', () async {
      await runCopyItemsToRemoteTest(
        uid: '123',
        products: [
          makeProduct(id: '1', availableQuantity: 10),
        ],
        itemsToAdd: {'1': 6},
        itemsInCart: {'1': 6},
        expectedItemsInCart: {'1': 10},
      );
    });

    test('multiple items', () async {
      await runCopyItemsToRemoteTest(
        uid: '123',
        products: [
          makeProduct(id: '1', availableQuantity: 10),
          makeProduct(id: '2', availableQuantity: 10),
        ],
        itemsToAdd: {'1': 6, '2': 1, '3': 2},
        itemsInCart: {'1': 6},
        expectedItemsInCart: {'1': 10, '2': 1},
      );
    });
  });
}
