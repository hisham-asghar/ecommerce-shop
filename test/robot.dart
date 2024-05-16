import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/app.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/data/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/data/fake_address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/data/firebase_address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/fake_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/local_cart/fake_local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/local_cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/local_cart/sembast_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/remote_cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/remote_cart/fake_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/remote_cart/firebase_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/cloud_functions/fake_cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/cloud_functions/firebase_cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/payments/fake_payments_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/payments/payments_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/payments/stripe_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/data/fake_orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/data/firebase_orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/data/orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/fake_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/firebase_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/search_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/data/reviews_repository.dart';
import 'package:uuid/uuid.dart';

import 'src/features/address/address_robot.dart';
import 'src/features/authentication/auth_robot.dart';
import 'src/features/cart/cart_robot.dart';
import 'src/features/checkout/checkout_robot.dart';
import 'src/features/products/products_robot.dart';
import 'src/features/reviews/reviews_robot.dart';

class Robot {
  Robot(this.tester)
      : products = ProductsRobot(tester),
        cart = CartRobot(tester),
        reviews = ReviewsRobot(tester),
        auth = AuthRobot(tester),
        checkout = CheckoutRobot(tester),
        address = AddressRobot(tester);
  final WidgetTester tester;

  final ProductsRobot products;
  final CartRobot cart;
  final ReviewsRobot reviews;
  final AuthRobot auth;
  final CheckoutRobot checkout;
  final AddressRobot address;

  Future<void> pumpWidgetAppWithMocks(
      {bool initTestProducts = true, bool settle = true}) async {
    const addDelay = false;
    final uuid = const Uuid().v1();
    final authRepository =
        FakeAuthRepository(addDelay: addDelay, uidBuilder: () => uuid);
    final addressRepository = FakeAddressRepository(addDelay: addDelay);
    final productsRepository = FakeProductsRepository(addDelay: addDelay);
    if (initTestProducts) {
      productsRepository.initWithTestProducts();
    }
    final reviewsRepository = FakeReviewsRepository(addDelay: addDelay);
    final cartRepository = FakeCartRepository(addDelay: addDelay);
    final ordersRepository = FakeOrdersRepository(
      productsRepository: productsRepository,
      cartRepository: cartRepository,
      reviewsRepository: reviewsRepository,
      addDelay: addDelay,
    );
    final localCartRepository = FakeLocalCartRepository(addDelay: addDelay);
    final cloudFunctionsRepository =
        FakeCloudFunctionsRepository(ordersRepository: ordersRepository);
    final paymentRepository = FakePaymentsRepository(
      authRepository: authRepository,
      ordersRepository: ordersRepository,
      addDelay: addDelay,
    );
    await tester.pumpWidget(ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        addressRepositoryProvider.overrideWithValue(addressRepository),
        productsRepositoryProvider.overrideWithValue(productsRepository),
        searchRepositoryProvider.overrideWithValue(productsRepository),
        reviewsRepositoryProvider.overrideWithValue(reviewsRepository),
        cartRepositoryProvider.overrideWithValue(cartRepository),
        ordersRepositoryProvider.overrideWithValue(ordersRepository),
        localCartRepositoryProvider.overrideWithValue(localCartRepository),
        cloudFunctionsRepositoryProvider
            .overrideWithValue(cloudFunctionsRepository),
        paymentsRepositoryProvider.overrideWithValue(paymentRepository),
      ],
      child: const MyApp(),
    ));
    if (settle) {
      await tester.pumpAndSettle();
    }
  }

  Future<void> pumpWidgetAppWithFirebaseEmulator({bool settle = true}) async {
    await Firebase.initializeApp();
    // Use local Auth emulator
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    // Use local Firestore emulator
    final firestore = FirebaseFirestore.instance;
    firestore.settings =
        const Settings(persistenceEnabled: false, sslEnabled: false);
    firestore.useFirestoreEmulator('localhost', 8080);
    // Use local Functions emulator
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 8081);

    final authRepository = FirebaseAuthRepository(FirebaseAuth.instance);
    final addressRepository =
        FirebaseAddressRepository(FirebaseFirestore.instance);
    final productsRepository =
        FirebaseProductsRepository(FirebaseFirestore.instance);
    final cartRepository = FirebaseCartRepository(FirebaseFirestore.instance);
    final ordersRepository =
        FirebaseOrdersRepository(FirebaseFirestore.instance);
    final localCartRepository = await SembastCartRepository.makeDefault();
    final cloudFunctionsRepository = FirebaseCloudFunctionsRepository(
        FirebaseFunctions.instanceFor(region: 'us-central1'));
    // TODO: Can we mock this to short-circuit purchase path and write order in Firestore?
    final paymentRepository = StripeRepository(Stripe.instance);
    runApp(ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        addressRepositoryProvider.overrideWithValue(addressRepository),
        productsRepositoryProvider.overrideWithValue(productsRepository),
        cartRepositoryProvider.overrideWithValue(cartRepository),
        ordersRepositoryProvider.overrideWithValue(ordersRepository),
        localCartRepositoryProvider.overrideWithValue(localCartRepository),
        cloudFunctionsRepositoryProvider
            .overrideWithValue(cloudFunctionsRepository),
        paymentsRepositoryProvider.overrideWithValue(paymentRepository),
      ],
      child: const MyApp(),
    ));
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      exit(1);
    };
    if (settle) {
      await tester.pumpAndSettle();
    }
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

  // Full purchase flow
  Future<void> fullPurchaseFlow() async {
    await products.selectProduct();
    await products.setProductQuantity(3);
    await cart.addToCart();
    await cart.openCart();
    cart.expectFindNCartItems(1);
    await checkout.startCheckout();
    await auth.createAccount();
    await address.enterAddress();
    cart.expectFindNCartItems(1);
    await checkout.startPayment();
    cart.expectFindZeroCartItems();
    // when a payment is complete, user is taken to the orders page
    await closePage(); // close orders page
    await products.selectProduct(); // back to the product page
    reviews.expectFindLeaveReview(); // the review button is now visible
    await reviews.leaveReview(); // tap on it
    await reviews
        .createAndSubmitReview(); // submit review and get back to product page
    reviews.expectFindOneReview();
    await products.showMenu();
    await auth.openAccountPage();
    await auth.logout();
  }
}
