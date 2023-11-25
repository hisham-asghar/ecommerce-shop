import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';

abstract class CloudFunctionsRepository {
  Future<Order> placeOrder(String uid);
}

final cloudFunctionsRepositoryProvider =
    Provider<CloudFunctionsRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
