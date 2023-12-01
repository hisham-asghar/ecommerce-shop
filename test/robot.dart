import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/app.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/item_quantity_selector.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/address/address_page.dart';
import 'package:my_shop_ecommerce_flutter/src/features/home_app_bar/shopping_cart_icon.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_list/product_card.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/features/sign_in/email_password_sign_in_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/fake_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/fake_cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/fake_address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/fake_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/fake_local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/fake_orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/fake_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/provider_logger.dart';

class Robot {
  Robot(this.tester);
  final WidgetTester tester;

  Future<void> pumpWidgetAppWithMocks(
      {bool initTestProducts = true, bool settle = true}) async {
    const addDelay = false;
    final authRepository = FakeAuthRepository();
    final addressRepository = FakeAddressRepository(addDelay: addDelay);
    final productsRepository = FakeProductsRepository(addDelay: addDelay);
    if (initTestProducts) {
      productsRepository.initWithTestProducts();
    }
    final cartRepository = FakeCartRepository(
        productsRepository: productsRepository, addDelay: addDelay);
    final ordersRepository = FakeOrdersRepository(
      productsRepository: productsRepository,
      cartRepository: cartRepository,
      addDelay: addDelay,
    );
    final localCartRepository = FakeLocalCartRepository(
        productsRepository: productsRepository, addDelay: addDelay);
    final cloudFunctionsRepository =
        FakeCloudFunctionsRepository(ordersRepository: ordersRepository);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        addressRepositoryProvider.overrideWithValue(addressRepository),
        productsRepositoryProvider.overrideWithValue(productsRepository),
        cartRepositoryProvider.overrideWithValue(cartRepository),
        ordersRepositoryProvider.overrideWithValue(ordersRepository),
        localCartRepositoryProvider.overrideWithValue(localCartRepository),
        cloudFunctionsRepositoryProvider
            .overrideWithValue(cloudFunctionsRepository),
      ],
      child: const MyApp(),
    ));
    if (settle) {
      await tester.pumpAndSettle();
    }
  }

  // products list
  Future<void> selectProduct({int atIndex = 0}) async {
    final finder = find.byKey(ProductCard.productCardKey);
    await tester.tap(finder.at(atIndex));
    // wait for navigation
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

  Future<void> addToCart() async {
    final finder = find.text('Add to Cart');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  // shopping cart
  Future<void> openCart() async {
    final finder = find.byKey(ShoppingCartIcon.shoppingCartIconKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  void expectProductIsOutOfStock() async {
    final finder = find.text('Out of Stock');
    expect(finder, findsOneWidget);
  }

  Future<void> incrementCartItemQuantity(
      {required int quantity, required int atIndex}) async {
    final finder = find.byKey(ItemQuantitySelector.incrementKey(atIndex));
    expect(finder, findsOneWidget);
    for (var i = 0; i < quantity; i++) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }

  Future<void> decrementCartItemQuantity(
      {required int quantity, required int atIndex}) async {
    final finder = find.byKey(ItemQuantitySelector.decrementKey(atIndex));
    expect(finder, findsOneWidget);
    for (var i = 0; i < quantity; i++) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }

  Future<void> deleteCartItem({required int atIndex}) async {
    final finder = find.byKey(ShoppingCartItemContents.deleteKey(atIndex));
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  void expectShoppingCartIsLoading() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }

  void expectShoppingCartEmpty() {
    final finder = find.text('Shopping Cart is empty');
    expect(finder, findsOneWidget);
  }

  void expectFindNCartItems(int count) {
    final finder = find.byType(ShoppingCartItem);
    expect(finder, findsNWidgets(count));
  }

  Text getItemQuantityWidget({int? atIndex}) {
    final finder = find.byKey(ItemQuantitySelector.quantityKey(atIndex));
    expect(finder, findsOneWidget);
    return finder.evaluate().single.widget as Text;
  }

  void expectItemQuantity({required int quantity, int? atIndex}) {
    final text = getItemQuantityWidget(atIndex: atIndex);
    expect(text.data, '$quantity');
  }

  Future<void> startCheckout() async {
    final finder = find.text('Checkout');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  // sign in
  Future<void> signIn() async {
    final emailFinder = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(emailFinder, findsOneWidget);
    await tester.enterText(emailFinder, 'test@test.com');

    final passwordFinder = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(passwordFinder, findsOneWidget);
    await tester.enterText(passwordFinder, 'test@test.com');

    final ctaFinder = find.text('Sign in');
    expect(ctaFinder, findsOneWidget);
    await tester.tap(ctaFinder);
    await tester.pumpAndSettle();
  }

  // address
  Future<void> enterAddress() async {
    for (final key in [
      AddressPage.addressKey,
      AddressPage.townCityKey,
      AddressPage.stateKey,
      AddressPage.postalCodeKey,
      AddressPage.countryKey,
    ]) {
      final finder = find.byKey(key);
      expect(finder, findsOneWidget);
      await tester.enterText(finder, 'a');
    }

    final ctaFinder = find.text('Submit');
    expect(ctaFinder, findsOneWidget);
    await tester.tap(ctaFinder);
    await tester.pumpAndSettle();
  }

  // payment
  Future<void> startPayment() async {
    final finder = find.text('Pay by card');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> payWithCard() async {
    final finder = find.text('Pay');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  void expectPaymentComplete() {
    // app bar title
    expect(find.text('Payment Complete'), findsOneWidget);
  }

  // navigation
  Future<void> closePage() async {
    final finder = find.bySemanticsLabel('Close');
    //final finder = find.byIcon(Icons.close);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> goBack() async {
    final finder = find.bySemanticsLabel('Back');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }
}
