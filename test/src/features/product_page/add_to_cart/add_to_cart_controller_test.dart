import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen_state.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/address.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/mock_auth_repository.dart';

void main() {
  group('CheckoutScreenController', () {
    test('null user, show tabs', () {
      expect(
        CheckoutScreenController.stateFor(
          user: null,
          address: null,
          shouldShowTabs: true,
        ),
        const CheckoutScreenState.tab(0),
      );
    });

    test('signed in, null address, show tabs', () {
      expect(
        CheckoutScreenController.stateFor(
          user: MockAppUser(uid: '123'),
          address: null,
          shouldShowTabs: true,
        ),
        const CheckoutScreenState.tab(1),
      );
    });

    test('signed in, valid address, show tabs', () {
      expect(
        CheckoutScreenController.stateFor(
          user: MockAppUser(uid: '123'),
          address: Address(
              address: '', city: '', state: '', postalCode: '', country: ''),
          shouldShowTabs: true,
        ),
        const CheckoutScreenState.tab(2),
      );
    });

    test('signed in, valid address, no tabs', () {
      expect(
        CheckoutScreenController.stateFor(
          user: MockAppUser(uid: '123'),
          address: Address(
              address: '', city: '', state: '', postalCode: '', country: ''),
          shouldShowTabs: false,
        ),
        const CheckoutScreenState.noTabs(),
      );
    });
  });
}
