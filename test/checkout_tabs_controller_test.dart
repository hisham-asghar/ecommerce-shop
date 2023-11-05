import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_tabs_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/services/mock_auth_service.dart';

class MockTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker((_) {});
  }
}

void main() {
  group('checkout tabs controller', () {
    test('not signed in - index 0', () {
      final tabController =
          TabController(length: 3, vsync: MockTickerProvider());
      final checkoutTabsController = CheckoutTabsController(
        currentUser: null,
        address: null,
        tabController: tabController,
      );
      checkoutTabsController.updateIndex();
      expect(tabController.index, 0);
      // TODO: Test notifyListeners is called.
    });

    test('signed in, no address - index 1', () {
      final tabController =
          TabController(length: 3, vsync: MockTickerProvider());
      final checkoutTabsController = CheckoutTabsController(
        currentUser: MockAppUser(uid: '123', isAdmin: false, isSignedIn: true),
        address: null,
        tabController: tabController,
      );
      checkoutTabsController.updateIndex();
      expect(tabController.index, 1);
    });
    test('signed in, address - index 2', () async {
      final tabController =
          TabController(length: 3, vsync: MockTickerProvider());
      final checkoutTabsController = CheckoutTabsController(
        currentUser: MockAppUser(uid: '123', isAdmin: false, isSignedIn: true),
        address: Address(
            address: '', city: '', state: '', postalCode: '', country: ''),
        tabController: tabController,
      );
      checkoutTabsController.updateIndex();
      expect(tabController.index, 2);
    });
  });
}
