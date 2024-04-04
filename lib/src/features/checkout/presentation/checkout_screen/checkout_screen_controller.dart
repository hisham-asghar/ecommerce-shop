import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/data/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/auth_repository.dart';

/// All possible routes in the checkout flow
enum CheckoutSubRoute { register, address, payment }

class CheckoutScreenController
    extends StateNotifier<AsyncValue<CheckoutSubRoute>> {
  CheckoutScreenController(
      {required this.authRepository, required this.addressRepository})
      : super(const AsyncValue.loading()) {
    updateSubRoute();
  }

  final AuthRepository authRepository;
  final AddressRepository addressRepository;

  Future<void> updateSubRoute() async {
    final route = await _evaluateRoute();
    state = AsyncValue.data(route);
  }

  Future<CheckoutSubRoute> _evaluateRoute() async {
    final currentUser = authRepository.currentUser;
    if (currentUser != null) {
      final address = await addressRepository.fetchAddress(currentUser.uid);
      if (address != null) {
        return CheckoutSubRoute.payment;
      } else {
        return CheckoutSubRoute.address;
      }
    } else {
      return CheckoutSubRoute.register;
    }
  }
}

final checkoutScreenControllerProvider = StateNotifierProvider.autoDispose<
    CheckoutScreenController, AsyncValue<CheckoutSubRoute>>((ref) {
  return CheckoutScreenController(
    authRepository: ref.watch(authRepositoryProvider),
    addressRepository: ref.watch(addressRepositoryProvider),
  );
});
