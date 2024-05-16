import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/app.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/data/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/data/fake_address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/fake_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/local_cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/local_cart/sembast_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/remote_cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/remote_cart/fake_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/cloud_functions/fake_cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/payments/fake_payments_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/payments/payments_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/data/fake_orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/data/orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/fake_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/data/reviews_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/search_repository.dart';
import 'package:uuid/uuid.dart';

Future<void> runAppWithMocks() async {
  // https://docs.flutter.dev/testing/errors
  await runZonedGuarded(() async {
    final uuid = const Uuid().v1();
    final authRepository = FakeAuthRepository(uidBuilder: () => uuid);
    final addressRepository = FakeAddressRepository();
    final productsRepository = FakeProductsRepository()..initWithTestProducts();
    final reviewsRepository = FakeReviewsRepository();
    final cartRepository = FakeCartRepository();
    final ordersRepository = FakeOrdersRepository(
      productsRepository: productsRepository,
      cartRepository: cartRepository,
      reviewsRepository: reviewsRepository,
    );
    final localCartRepository = await SembastCartRepository.makeDefault();
    final cloudFunctionsRepository =
        FakeCloudFunctionsRepository(ordersRepository: ordersRepository);
    final paymentRepository = FakePaymentsRepository(
        authRepository: authRepository, ordersRepository: ordersRepository);
    // https://gorouter.dev/url-path-strategy#turning-off-the-hash
    GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
    runApp(ProviderScope(
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
      //observers: [ProviderLogger()],
      child: const MyApp(),
    ));

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
  }, (Object error, StackTrace stack) {
    debugPrint(error.toString());
  });
}
