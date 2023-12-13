import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/order_payment_intent.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address.dart'
    as app;
import 'package:my_shop_ecommerce_flutter/src/repositories/stripe/payments_repository.dart';

class StripeRepository implements PaymentsRepository {
  StripeRepository(this._stripe);
  final Stripe _stripe;

  @override
  Future<void> initPaymentSheet({
    required OrderPaymentIntent orderPaymentIntent,
    required String email,
    required app.Address address,
  }) async {
    final billingDetails = BillingDetails(
      email: email,
      //phone: '+48888000888',
      address: Address(
        city: address.city,
        country: address.country,
        line1: address.address,
        line2: '',
        state: '',
        postalCode: address.postalCode,
      ),
    ); // mocked data for tests

    await _stripe.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // Main params
        paymentIntentClientSecret: orderPaymentIntent.paymentIntent,
        merchantDisplayName: 'MyShop',
        // Customer params
        customerId: orderPaymentIntent.customer,
        customerEphemeralKeySecret: orderPaymentIntent.ephemeralKey,
        // Extra params
        applePay: true,
        googlePay: true,
        style: ThemeMode.dark,
        primaryButtonColor: Colors.redAccent,
        billingDetails: billingDetails,
        testEnv: true,
        merchantCountryCode: 'GB',
      ),
    );
  }

  @override
  Future<void> presentPaymentSheet() async {
    return _stripe.presentPaymentSheet();
  }
}
