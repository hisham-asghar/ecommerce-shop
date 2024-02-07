import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/app.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/fake_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/fake_cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/fake_address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/remote/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/remote/fake_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local/sembast_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/fake_orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/fake_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/fake_reviews_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/reviews_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/search/search_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/stripe/fake_payments_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/stripe/payments_repository.dart';

Future<void> runAppWithMocks() async {
  // https://docs.flutter.dev/testing/errors
  await runZonedGuarded(() async {
    final authRepository = FakeAuthRepository();
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
