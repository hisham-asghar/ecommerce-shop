import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/order_payment_intent.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address.dart';

abstract class PaymentsRepository {
  Future<void> initPaymentSheet({
    required OrderPaymentIntent orderPaymentIntent,
    required String email,
    required Address address,
  });

  Future<void> presentPaymentSheet();
}

final paymentsRepositoryProvider = Provider<PaymentsRepository>((ref) {
  throw UnimplementedError();
});
