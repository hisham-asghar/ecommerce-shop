import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/data/fake_orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/domain/order_payment_intent.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/delay.dart';

class FakeCloudFunctionsRepository implements CloudFunctionsRepository {
  FakeCloudFunctionsRepository(
      {required this.ordersRepository, this.addDelay = true});
  final FakeOrdersRepository ordersRepository;
  final bool addDelay;

  @override
  Future<OrderPaymentIntent> createOrderPaymentIntent(String uid) async {
    await delay(addDelay);
    return OrderPaymentIntent(
      ephemeralKey: '123',
      paymentIntent: '456',
      customer: 'abc',
    );
  }
}
