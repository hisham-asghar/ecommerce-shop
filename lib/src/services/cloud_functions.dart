import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';

abstract class CloudFunctions {
  Future<Order> placeOrder(String uid);
}

final cloudFunctionsProvider = Provider<CloudFunctions>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
