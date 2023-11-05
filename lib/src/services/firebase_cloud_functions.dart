import 'package:cloud_functions/cloud_functions.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cloud_functions.dart';

class FirebaseCloudFunctions implements CloudFunctions {
  final functions = FirebaseFunctions.instanceFor(region: 'us-central1');

  @override
  Future<Order> placeOrder(String uid) async {
    final callable = functions.httpsCallable('placeOrder');
    final result = await callable();
    final data = Map<Object?, Object?>.from(result.data);
    final values =
        Map<String, dynamic>.from(data['data'] as Map<Object?, Object?>);
    final id = data['id'] as String;
    return Order.fromMap(values, id);
  }
}
