import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/domain/order_payment_intent.dart';

abstract class CloudFunctionsRepository {
  Future<OrderPaymentIntent> createOrderPaymentIntent(String uid);
}

final cloudFunctionsRepositoryProvider =
    Provider<CloudFunctionsRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
