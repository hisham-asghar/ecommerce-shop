import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/platform/platform_is.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/firebase_auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/mock_auth_service.dart';
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

  final authService = FirebaseAuthService();
  if (authService.currentUser == null) {
    await authService.signInAnonymously();
  }
  runApp(ProviderScope(
    overrides: [
      authServiceProvider.overrideWithValue(authService),
    ],
    observers: [ProviderLogger()],
    child: MyApp(),
  ));
}
