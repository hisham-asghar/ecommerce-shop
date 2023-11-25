import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/platform/platform_is.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/mock_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/mock_cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/data_store/data_store.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/data_store/mock_data_store.dart';
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

  final authRepository = MockAuthRepository();
  final dataStore = MockDataStore();
  final localDataStore = await SembastCartStore.makeDefault();
  final cloudFunctionsRepository = MockCloudFunctionsRepository(dataStore);
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
