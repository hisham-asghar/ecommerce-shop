import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/stripe/payments_repository.dart';

class CheckoutService {
  CheckoutService({
    required this.cloudFunctionsRepository,
    required this.paymentsRepository,
    required this.authRepository,
    required this.addressRepository,
  });
  final CloudFunctionsRepository cloudFunctionsRepository;
  final PaymentsRepository paymentsRepository;
  final AuthRepository authRepository;
  final AddressRepository addressRepository;

  Future<void> payWithPaymentSheet() async {
    // 1. Creates order document, sets up stripe payment intent
    final user = authRepository.currentUser!;
    final paymentIntent =
        await cloudFunctionsRepository.createOrderPaymentIntent(user.uid);

    // 2. initialize the payment sheet
    final address = await addressRepository.getAddress(user.uid);
    if (address == null) {
      throw AssertionError('Address is null');
    }
    await paymentsRepository.initPaymentSheet(
      orderPaymentIntent: paymentIntent,
      email: user.email!,
      address: address,
    );

    // 3. Present payment sheet
    await paymentsRepository.presentPaymentSheet();
  }

  Future<void> payByCard(bool saveCard) async {
    // 1. Creates order document, sets up stripe payment intent
    final user = authRepository.currentUser!;
    final paymentIntent =
        await cloudFunctionsRepository.createOrderPaymentIntent(user.uid);

    // 2. initialize the payment sheet
    final address = await addressRepository.getAddress(user.uid);
    if (address == null) {
      throw AssertionError('Address is null');
    }
    await paymentsRepository.confirmPayment(
      orderPaymentIntent: paymentIntent,
      email: user.email!,
      address: address,
      saveCard: saveCard,
    );
  }
}

final checkoutServiceProvider = Provider<CheckoutService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final addressRepository = ref.watch(addressRepositoryProvider);
  final cloudFunctionsRepository = ref.watch(cloudFunctionsRepositoryProvider);
  final paymentRepository = ref.watch(paymentsRepositoryProvider);
  return CheckoutService(
    authRepository: authRepository,
    addressRepository: addressRepository,
    cloudFunctionsRepository: cloudFunctionsRepository,
    paymentsRepository: paymentRepository,
  );
});
