import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/app.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/data/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/data/firebase_address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/local_cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/local_cart/sembast_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/remote_cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/remote_cart/firebase_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/cloud_functions/firebase_cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/payments/payments_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/payments/stripe_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/data/firebase_orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/data/orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/firebase_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/data/firebase_reviews_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/data/reviews_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/search_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> runAppWithFirebase() async {
  // https://docs.flutter.dev/testing/errors
  await runZonedGuarded(() async {
    final authRepository = FirebaseAuthRepository(FirebaseAuth.instance);
    final addressRepository =
        FirebaseAddressRepository(FirebaseFirestore.instance);
    final productsRepository =
        FirebaseProductsRepository(FirebaseFirestore.instance);
    final reviewsRepository =
        FirebaseReviewsRepository(FirebaseFirestore.instance);
    final cartRepository = FirebaseCartRepository(FirebaseFirestore.instance);
    final ordersRepository =
        FirebaseOrdersRepository(FirebaseFirestore.instance);
    final localCartRepository = await SembastCartRepository.makeDefault();
    final cloudFunctionsRepository = FirebaseCloudFunctionsRepository(
        FirebaseFunctions.instanceFor(region: 'us-central1'));
    final paymentRepository = StripeRepository(Stripe.instance);
    // https://gorouter.dev/url-path-strategy#turning-off-the-hash
    GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

    const sentryKey = String.fromEnvironment('SENTRY_KEY');
    if (sentryKey.isEmpty) {
      throw AssertionError('SENTRY_KEY is not set');
    }
    await SentryFlutter.init(
      (options) {
        options.dsn = sentryKey;
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
      },
      appRunner: () => runApp(
        ProviderScope(
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
        ),
      ),
    );
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          // TODO: Localize without context?
          title: Text(AppLocalizationsEn().anErrorOccurred),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }, (Object error, StackTrace stack) {
    debugPrint(error.toString());
  });
}
