import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/platform/platform_is.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cloud_functions/cloud_functions.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store/data_store.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth/mock_auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cloud_functions/mock_cloud_functions.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store/mock_data_store.dart';
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

  final authService = MockAuthService();
  if (authService.currentUser == null) {
    await authService.signInAnonymously();
  }
  final dataStore = MockDataStore();
  final cloudFunctions = MockCloudFunctions(dataStore);
  runApp(ProviderScope(
    overrides: [
      authServiceProvider.overrideWithValue(authService),
      dataStoreProvider.overrideWithValue(dataStore),
      cloudFunctionsProvider.overrideWithValue(cloudFunctions),
    ],
    observers: [ProviderLogger()],
    child: MyApp(),
  ));
}
