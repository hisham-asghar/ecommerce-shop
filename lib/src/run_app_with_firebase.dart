import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/app.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/firebase_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/firebase_address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/firebase_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/firebase_cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/sembast_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/firebase_orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/firebase_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/stripe/payments_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/stripe/stripe_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/provider_logger.dart';

Future<void> runAppWithFirebase() async {
  // https://docs.flutter.dev/testing/errors
  await runZonedGuarded(() async {
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
    final paymentRepository = StripeRepository(Stripe.instance);
    // https://gorouter.dev/url-path-strategy#turning-off-the-hash
    GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
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
      observers: [ProviderLogger()],
      child: const MyApp(),
    ));
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
  }, (Object error, StackTrace stack) {
    print(error);
  });
}
