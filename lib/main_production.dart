import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/platform/platform_is.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/firebase_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/data_store/data_store.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/firebase_cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/data_store/firebase_data_store.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/data_store/sembast_cart_store.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/provider_logger.dart';

import 'src/app.dart';

void main() async {
  // TODO: Uncomment this when implementing Stripe payments
  // TODO: Add platform checks to disable on desktop
  WidgetsFlutterBinding.ensureInitialized();
  if (PlatformIs.iOS || PlatformIs.android) {
    // TODO: Provide key
    //Stripe.publishableKey = stripePublishableKey;
    // Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
    // Stripe.urlScheme = 'flutterstripe';
    // await Stripe.instance.applySettings();
  }

  final authRepository = FirebaseAuthRepository(FirebaseAuth.instance);
  final dataStore = FirebaseDataStore(FirebaseFirestore.instance);
  final localDataStore = await SembastCartStore.makeDefault();
  final cloudFunctionsRepository = FirebaseCloudFunctionsRepository(
      FirebaseFunctions.instanceFor(region: 'us-central1'));
  runApp(ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      dataStoreProvider.overrideWithValue(dataStore),
      localCartDataStoreProvider.overrideWithValue(localDataStore),
      cloudFunctionsRepositoryProvider
          .overrideWithValue(cloudFunctionsRepository),
    ],
    observers: [ProviderLogger()],
    child: MyApp(),
  ));
}
