import 'package:my_shop_ecommerce_flutter/src/repositories/auth/fake_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order_payment_intent.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart' as app;
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/fake_orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/stripe/payments_repository.dart';

class FakePaymentsRepository implements PaymentsRepository {
  FakePaymentsRepository({
    required this.authRepository,
    required this.ordersRepository,
    this.addDelay = true,
  });
  final bool addDelay;
  final FakeAuthRepository authRepository;
  final FakeOrdersRepository ordersRepository;

  @override
  Future<void> initPaymentSheet({
    required OrderPaymentIntent orderPaymentIntent,
    required String email,
    required app.Address address,
  }) async {
    await delay(addDelay);
  }

  @override
  Future<void> presentPaymentSheet() async {
    final uid = authRepository.currentUser!.uid;
    await ordersRepository.placeOrder(uid);
  }

  @override
  Future<void> confirmPayment({
    required OrderPaymentIntent orderPaymentIntent,
    required String email,
    required app.Address address,
    required bool saveCard,
  }) async {
    final uid = authRepository.currentUser!.uid;
    await ordersRepository.placeOrder(uid);
  }
}
