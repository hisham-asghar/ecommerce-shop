import 'package:cloud_functions/cloud_functions.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order_payment_intent.dart';

class FirebaseCloudFunctionsRepository implements CloudFunctionsRepository {
  FirebaseCloudFunctionsRepository(this._functions);
  final FirebaseFunctions _functions;

  @override
  Future<OrderPaymentIntent> createOrderPaymentIntent(String uid) async {
    final callable = _functions.httpsCallable('createOrderPaymentIntent');
    final result = await callable();
    final data = Map<Object?, Object?>.from(result.data);
    final values = Map<String, dynamic>.from(data);
    return OrderPaymentIntent.fromMap(values);
  }

  // @override
  // Future<String> getStripePublicKey() async {
  //   final callable = _functions.httpsCallable('getStripePublicKeyCallable');
  //   final result = await callable();
  //   final data = Map<Object?, Object?>.from(result.data);
  //   final publicKey = data['publicKey'] as String;
  //   return publicKey;
  // }
}
