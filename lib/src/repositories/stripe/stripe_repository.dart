import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order_payment_intent.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart' as app;
import 'package:my_shop_ecommerce_flutter/src/repositories/stripe/payments_repository.dart';

class StripeRepository implements PaymentsRepository {
  StripeRepository(this._stripe);
  final Stripe _stripe;

  BillingDetails _getBillingDetails(String email, app.Address address) {
    return BillingDetails(
      email: email,
      address: Address(
        city: address.city,
        country: address.country,
        line1: address.address,
        line2: '',
        state: '',
        postalCode: address.postalCode,
      ),
    );
  }

  @override
  Future<void> initPaymentSheet({
    required OrderPaymentIntent orderPaymentIntent,
    required String email,
    required app.Address address,
  }) async {
    final billingDetails = _getBillingDetails(email, address);

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

  @override
  Future<void> confirmPayment({
    required OrderPaymentIntent orderPaymentIntent,
    required String email,
    required app.Address address,
    required bool saveCard,
  }) {
    final billingDetails = _getBillingDetails(email, address);

    return _stripe.confirmPayment(
        orderPaymentIntent.paymentIntent,
        PaymentMethodParams.card(
          billingDetails: billingDetails,
          setupFutureUsage:
              saveCard == true ? PaymentIntentsFutureUsage.OffSession : null,
        ));
  }
}
