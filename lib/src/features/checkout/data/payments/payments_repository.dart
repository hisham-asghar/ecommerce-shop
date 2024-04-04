import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/domain/order_payment_intent.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/domain/address.dart';

abstract class PaymentsRepository {
  Future<void> initPaymentSheet({
    required OrderPaymentIntent orderPaymentIntent,
    required String email,
    required Address address,
  });

  Future<void> presentPaymentSheet();

  Future<void> confirmPayment({
    required OrderPaymentIntent orderPaymentIntent,
    required String email,
    required Address address,
    required bool saveCard,
  });
}

final paymentsRepositoryProvider = Provider<PaymentsRepository>((ref) {
  throw UnimplementedError();
});
