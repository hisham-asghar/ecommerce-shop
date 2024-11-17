import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:my_shop_ecommerce_flutter/src/exceptions/app_exception.dart';
import 'package:my_shop_ecommerce_flutter/src/exceptions/run_catching_exceptions.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/data/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/payments/payments_repository.dart';

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

  Future<Result<AppException, void>> payWithPaymentSheet() =>
      runCatchingExceptions(() async {
        // 1. Creates order document, sets up stripe payment intent
        final user = authRepository.currentUser!;
        final paymentIntent =
            await cloudFunctionsRepository.createOrderPaymentIntent(user.uid);

        // 2. initialize the payment sheet
        final address = await addressRepository.fetchAddress(user.uid);
        if (address == null) {
          // TODO: This is a programmer error
          // * will be returned as-is by [runCatchingExceptions]
          throw const AppException.missingAddress();
        }
        await paymentsRepository.initPaymentSheet(
          orderPaymentIntent: paymentIntent,
          email: user.email!,
          address: address,
        );

        // 3. Present payment sheet
        await paymentsRepository.presentPaymentSheet();
      });

  Future<Result<AppException, void>> payByCard(bool saveCard) =>
      runCatchingExceptions(() async {
        // 1. Creates order document, sets up stripe payment intent
        final user = authRepository.currentUser!;
        final paymentIntent =
            await cloudFunctionsRepository.createOrderPaymentIntent(user.uid);

        // 2. initialize the payment sheet
        final address = await addressRepository.fetchAddress(user.uid);
        if (address == null) {
          // * will be returned as-is by [runCatchingExceptions]
          throw const AppException.missingAddress();
        }
        await paymentsRepository.confirmPayment(
          orderPaymentIntent: paymentIntent,
          email: user.email!,
          address: address,
          saveCard: saveCard,
        );
      });
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
