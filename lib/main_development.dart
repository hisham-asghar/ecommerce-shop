import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_shop_ecommerce_flutter/firebase_options_dev.dart';
import 'package:my_shop_ecommerce_flutter/src/platform/platform_is.dart';
import 'package:my_shop_ecommerce_flutter/src/run_app_with_firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Use local Auth emulator
  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // Use local Firestore emulator
  final firestore = FirebaseFirestore.instance;
  firestore.settings =
      const Settings(persistenceEnabled: false, sslEnabled: false);
  firestore.useFirestoreEmulator('localhost', 8080);
  // Use local Functions emulator
  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 8081);
  // Stripe setup
  if (PlatformIs.iOS || PlatformIs.android) {
    const publicKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
    if (publicKey.isEmpty) {
      throw AssertionError('STRIPE_PUBLISHABLE_KEY is not set');
    }
    Stripe.publishableKey = publicKey;
    await Stripe.instance.applySettings();
  }

  runAppWithFirebase();
}
