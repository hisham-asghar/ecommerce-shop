import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen_model_state.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store/data_store.dart';

class CheckoutScreenModel extends StateNotifier<CheckoutScreenModelState> {
  CheckoutScreenModel({required this.authService, required this.dataStore})
      : super(const CheckoutScreenModelState.loading()) {
    init();
  }

  final AuthService authService;
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
    final initialUser = authService.currentUser;
    final initialAddress = initialUser != null
        ? await dataStore.getAddress(initialUser.uid)
        : null;
    final shouldShowTabs =
        initialUser?.isSignedIn == false || initialAddress == null;
    state = stateFor(
        user: initialUser,
        address: initialAddress,
        shouldShowTabs: shouldShowTabs);

    // Then, get updates if tabs should be shown
    if (shouldShowTabs) {
      _userSubscription = authService.authStateChanges().listen((user) {
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

  static CheckoutScreenModelState stateFor(
      {AppUser? user, Address? address, required bool shouldShowTabs}) {
    if (shouldShowTabs) {
      if (user != null && user.isSignedIn) {
        if (address != null) {
          return const CheckoutScreenModelState.tab(2);
        } else {
          return const CheckoutScreenModelState.tab(1);
        }
      } else {
        return const CheckoutScreenModelState.tab(0);
      }
    } else {
      return const CheckoutScreenModelState.noTabs();
    }
  }
}

final checkoutScreenModelProvider = StateNotifierProvider.autoDispose<
    CheckoutScreenModel, CheckoutScreenModelState>((ref) {
  return CheckoutScreenModel(
    authService: ref.watch(authServiceProvider),
    dataStore: ref.watch(dataStoreProvider),
  );
});
