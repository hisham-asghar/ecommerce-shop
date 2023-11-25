import 'package:cloud_functions/cloud_functions.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';

class FirebaseCloudFunctionsRepository implements CloudFunctionsRepository {
  FirebaseCloudFunctionsRepository(this._functions);
  final FirebaseFunctions _functions;

  @override
  Future<Order> placeOrder(String uid) async {
    final callable = _functions.httpsCallable('placeOrder');
    final result = await callable();
    final data = Map<Object?, Object?>.from(result.data);
    final values =
        Map<String, dynamic>.from(data['data'] as Map<Object?, Object?>);
    final id = data['id'] as String;
    return Order.fromMap(values, id);
  }
}
