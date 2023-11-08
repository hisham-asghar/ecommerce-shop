import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen_model.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen_model_state.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth/mock_auth_service.dart';

void main() {
  group('checkout screen model', () {
    test('null user, show tabs', () {
      expect(
        CheckoutScreenModel.stateFor(
          user: null,
          address: null,
          shouldShowTabs: true,
        ),
        const CheckoutScreenModelState.tab(0),
      );
    });

    test('not signed in, show tabs', () {
      expect(
        CheckoutScreenModel.stateFor(
          user: MockAppUser(uid: '123', isSignedIn: false, isAdmin: false),
          address: null,
          shouldShowTabs: true,
        ),
        const CheckoutScreenModelState.tab(0),
      );
    });

    test('signed in, null address, show tabs', () {
      expect(
        CheckoutScreenModel.stateFor(
          user: MockAppUser(uid: '123', isSignedIn: true, isAdmin: false),
          address: null,
          shouldShowTabs: true,
        ),
        const CheckoutScreenModelState.tab(1),
      );
    });

    test('signed in, valid address, show tabs', () {
      expect(
        CheckoutScreenModel.stateFor(
          user: MockAppUser(uid: '123', isSignedIn: true, isAdmin: false),
          address: Address(
              address: '', city: '', state: '', postalCode: '', country: ''),
          shouldShowTabs: true,
        ),
        const CheckoutScreenModelState.tab(2),
      );
    });

    test('signed in, valid address, no tabs', () {
      expect(
        CheckoutScreenModel.stateFor(
          user: MockAppUser(uid: '123', isSignedIn: true, isAdmin: false),
          address: Address(
              address: '', city: '', state: '', postalCode: '', country: ''),
          shouldShowTabs: false,
        ),
        const CheckoutScreenModelState.noTabs(),
      );
    });
  });
}
