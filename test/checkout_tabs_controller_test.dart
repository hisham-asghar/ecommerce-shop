import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_tabs_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/mock_data_store.dart';

class MockTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker((_) {});
  }
}

void main() {
  group('checkout tabs controller', () {
    test('not signed in - index 0', () {
      final mockAuthService = MockAuthService();
      final mockDataStore = MockDataStore();
      final tabController =
          TabController(length: 3, vsync: MockTickerProvider());
      final checkoutTabsController = CheckoutTabsController(
        authService: mockAuthService,
        dataStore: mockDataStore,
        tabController: tabController,
      );
      checkoutTabsController.updateIndex();
      expect(tabController.index, 0);
      // TODO: Test notifyListeners is called.
    });

    test('signed in, no address - index 1', () {
      final mockAuthService = MockAuthService();
      mockAuthService.isSignedIn = true;
      mockAuthService.uid = '123';
      final mockDataStore = MockDataStore();
      final tabController =
          TabController(length: 3, vsync: MockTickerProvider());
      final checkoutTabsController = CheckoutTabsController(
        authService: mockAuthService,
        dataStore: mockDataStore,
        tabController: tabController,
      );
      checkoutTabsController.updateIndex();
      expect(tabController.index, 1);
    });
    test('signed in, address - index 2', () async {
      final mockAuthService = MockAuthService();
      mockAuthService.isSignedIn = true;
      mockAuthService.uid = '123';
      final mockDataStore = MockDataStore();
      await mockDataStore.submitAddress(
          '123',
          Address(
              address: '', city: '', state: '', postalCode: '', country: ''));
      final tabController =
          TabController(length: 3, vsync: MockTickerProvider());
      final checkoutTabsController = CheckoutTabsController(
        authService: mockAuthService,
        dataStore: mockDataStore,
        tabController: tabController,
      );
      checkoutTabsController.updateIndex();
      expect(tabController.index, 2);
    });
  });
}
