import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen_state.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/address.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/data_store/data_store.dart';

class CheckoutScreenController extends StateNotifier<CheckoutScreenState> {
  CheckoutScreenController(
      {required this.authRepository, required this.dataStore})
      : super(const CheckoutScreenState.loading()) {
    init();
  }

  final AuthRepository authRepository;
  final DataStore dataStore;

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
        ? await dataStore.getAddress(initialUser.uid)
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
          _addressSubscription = dataStore.address(user.uid).listen((address) {
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
    dataStore: ref.watch(dataStoreProvider),
  );
});
