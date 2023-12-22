import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/fake_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';

import '../../mocks.dart';
import '../../utils.dart';

void main() {
  group('copyItemsToRemote', () {
    late MockAuthRepository mockAuthRepository;
    late MockCartRepository mockCartRepository;
    late MockLocalCartRepository mockLocalCartRepository;
    late MockProductsRepository mockProductsRepository;
    late MockCloudFunctionsRepository mockCloudFunctionsRepository;
    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockCartRepository = MockCartRepository();
      mockLocalCartRepository = MockLocalCartRepository();
      mockProductsRepository = MockProductsRepository();
      mockCloudFunctionsRepository = MockCloudFunctionsRepository();
      registerFallbackValue(<Item>[]);
    });

    CartService makeCartService() => CartService(
          authRepository: mockAuthRepository,
          cartRepository: mockCartRepository,
          localCartRepository: mockLocalCartRepository,
          productsRepository: mockProductsRepository,
          cloudFunctions: mockCloudFunctionsRepository,
        );

    Future<void> runCopyItemsToRemoteTest({
      required String uid,
      required List<Product> products,
      required List<Item> itemsToAdd,
      required List<Item> itemsInCart,
      required List<Item> expectedItemsAdded,
    }) async {
      when(() => mockAuthRepository.currentUser)
          .thenReturn(FakeAppUser(uid: uid));
      when(() => mockLocalCartRepository.getItemsList())
          .thenAnswer((_) => Future.value(itemsToAdd));
      when(() => mockProductsRepository.getProductsList())
          .thenAnswer((_) => Future.value(products));
      when(() => mockCartRepository.getItemsList(uid))
          .thenAnswer((_) => Future.value(itemsInCart));
      when(() => mockCartRepository.addAllItems(uid, expectedItemsAdded))
          .thenAnswer((_) => Future.value());
      when(() => mockLocalCartRepository.clear())
          .thenAnswer((_) => Future.value());
      final cartService = makeCartService();
      // run
      await cartService.copyItemsToRemote();
      // verify
      verify(() => mockCartRepository.addAllItems(uid, expectedItemsAdded))
          .called(1);
    }

    test('local quantity <= available quantity', () async {
      await runCopyItemsToRemoteTest(
        uid: '123',
        products: [
          makeProduct(id: '1', availableQuantity: 10),
        ],
        itemsToAdd: [
          Item(productId: '1', quantity: 1),
        ],
        itemsInCart: [],
        expectedItemsAdded: [
          Item(productId: '1', quantity: 1),
        ],
      );
    });
    test('local quantity > available quantity', () async {
      await runCopyItemsToRemoteTest(
        uid: '123',
        products: [
          makeProduct(id: '1', availableQuantity: 10),
        ],
        itemsToAdd: [
          Item(productId: '1', quantity: 15),
        ],
        itemsInCart: [],
        expectedItemsAdded: [
          Item(productId: '1', quantity: 10),
        ],
      );
    });

    test('local + remote quantity <= available quantity', () async {
      await runCopyItemsToRemoteTest(
        uid: '123',
        products: [
          makeProduct(id: '1', availableQuantity: 10),
        ],
        itemsToAdd: [
          Item(productId: '1', quantity: 1),
        ],
        itemsInCart: [
          Item(productId: '1', quantity: 1),
        ],
        expectedItemsAdded: [
          Item(productId: '1', quantity: 1),
        ],
      );
    });

    test('local + remote quantity > available quantity', () async {
      await runCopyItemsToRemoteTest(
        uid: '123',
        products: [
          makeProduct(id: '1', availableQuantity: 10),
        ],
        itemsToAdd: [
          Item(productId: '1', quantity: 6),
        ],
        itemsInCart: [
          Item(productId: '1', quantity: 6),
        ],
        expectedItemsAdded: [
          Item(productId: '1', quantity: 4),
        ],
      );
    });

    test('multiple items', () async {
      await runCopyItemsToRemoteTest(
        uid: '123',
        products: [
          makeProduct(id: '1', availableQuantity: 10),
          makeProduct(id: '2', availableQuantity: 10),
        ],
        itemsToAdd: [
          Item(productId: '1', quantity: 6),
          Item(productId: '2', quantity: 1),
          Item(productId: '3', quantity: 2),
        ],
        itemsInCart: [
          Item(productId: '1', quantity: 6),
        ],
        expectedItemsAdded: [
          Item(productId: '1', quantity: 4),
          Item(productId: '2', quantity: 1),
          // productId: '3' discarded as not found
        ],
      );
    });
  });
}
