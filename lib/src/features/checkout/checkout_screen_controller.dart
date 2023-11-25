import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen_state.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address_repository.dart';

class CheckoutScreenController extends StateNotifier<CheckoutScreenState> {
  CheckoutScreenController(
      {required this.authRepository, required this.addressRepository})
      : super(const CheckoutScreenState.loading()) {
    init();
  }

  // TODO: Should these access the services instead?
  final AuthRepository authRepository;
  final AddressRepository addressRepository;

  StreamSubscription? _userSubscription;
  StreamSubscription? _addressSubscription;

  @override
  void dispose() {
    _userSubscription?.cancel();
    _addressSubscription?.cancel();
    super.dispose();
  }

  void init() async {
    // First, determine the initial state
    final initialUser = authRepository.currentUser;
    final initialAddress = initialUser != null
        ? await addressRepository.getAddress(initialUser.uid)
        : null;
    final shouldShowTabs = initialUser == null || initialAddress == null;
    state = stateFor(
      user: initialUser,
      address: initialAddress,
      shouldShowTabs: shouldShowTabs,
    );

    // Then, get updates if tabs should be shown
    if (shouldShowTabs) {
      _userSubscription = authRepository.authStateChanges().listen((user) {
        if (user != null) {
          if (_addressSubscription != null) {
            _addressSubscription?.cancel();
          }
          _addressSubscription =
              addressRepository.address(user.uid).listen((address) {
            state =
                stateFor(user: user, address: address, shouldShowTabs: true);
          });
        } else {
          state = stateFor(user: user, address: null, shouldShowTabs: true);
        }
      });
    }
  }

  static CheckoutScreenState stateFor(
      {AppUser? user, Address? address, required bool shouldShowTabs}) {
    if (shouldShowTabs) {
      if (user != null) {
        if (address != null) {
          return const CheckoutScreenState.tab(2);
        } else {
          return const CheckoutScreenState.tab(1);
        }
      } else {
        return const CheckoutScreenState.tab(0);
      }
    } else {
      return const CheckoutScreenState.noTabs();
    }
  }
}

final checkoutScreenControllerProvider = StateNotifierProvider.autoDispose<
    CheckoutScreenController, CheckoutScreenState>((ref) {
  return CheckoutScreenController(
    authRepository: ref.watch(authRepositoryProvider),
    addressRepository: ref.watch(addressRepositoryProvider),
  );
});
