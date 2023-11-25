import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/platform/platform_is.dart';
import 'package:my_shop_ecommerce_flutter/src/run_app_with_mocks.dart';

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

  runAppWithMocks();
}
