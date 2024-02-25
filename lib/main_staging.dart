import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_shop_ecommerce_flutter/firebase_options_staging.dart';
import 'package:my_shop_ecommerce_flutter/src/run_app_with_firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Stripe setup
  if (kIsWeb || Platform.isIOS || Platform.isAndroid) {
    const publicKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
    if (publicKey.isEmpty) {
      throw AssertionError('STRIPE_PUBLISHABLE_KEY is not set');
    }
    Stripe.publishableKey = publicKey;
    // TODO: Update to production values
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
    Stripe.urlScheme = 'flutterstripe';
    await Stripe.instance.applySettings();
  }

  runAppWithFirebase();
}
