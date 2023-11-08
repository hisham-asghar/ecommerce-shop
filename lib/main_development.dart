import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/platform/platform_is.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth/firebase_auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cloud_functions/cloud_functions.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store/data_store.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cloud_functions/firebase_cloud_functions.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store/firebase_data_store.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store/sembast_cart_store.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/provider_logger.dart';

import 'src/app.dart';

void main() async {
  // TODO: Uncomment this when implementing Stripe payments
  // TODO: Add platform checks to disable on desktop
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Use local Firestore emulator
  final firestore = FirebaseFirestore.instance;
  firestore.settings =
      const Settings(persistenceEnabled: false, sslEnabled: false);
  firestore.useFirestoreEmulator('localhost', 8080);
  // Use local Functions emulator
  final functions = FirebaseFunctions.instance;
  functions.useFunctionsEmulator('localhost', 8081);
  // Stripe setup
  if (PlatformIs.iOS || PlatformIs.android) {
    // TODO: Provide key
    //Stripe.publishableKey = stripePublishableKey;
    // Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
    // Stripe.urlScheme = 'flutterstripe';
    // await Stripe.instance.applySettings();
  }

  final authService = FirebaseAuthService();
  final dataStore = FirebaseDataStore();
  final localDataStore = await SembastCartStore.makeDefault();
  final cloudFunctions = FirebaseCloudFunctions();
  runApp(ProviderScope(
    overrides: [
      authServiceProvider.overrideWithValue(authService),
      dataStoreProvider.overrideWithValue(dataStore),
      localCartDataStoreProvider.overrideWithValue(localDataStore),
      cloudFunctionsProvider.overrideWithValue(cloudFunctions),
    ],
    observers: [ProviderLogger()],
    child: MyApp(),
  ));
}
