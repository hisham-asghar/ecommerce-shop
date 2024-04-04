import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/fake_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/payments/payments_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/data/fake_orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/domain/order_payment_intent.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/domain/address.dart'
    as app;
import 'package:my_shop_ecommerce_flutter/src/utils/delay.dart';

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
