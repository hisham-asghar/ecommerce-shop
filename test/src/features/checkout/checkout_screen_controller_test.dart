import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/fake_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address.dart';

import '../../../mocks.dart';

void main() {
  const fakeUserId = '123';
  const fakeUser = FakeAppUser(uid: fakeUserId);
  group('CheckoutScreenController', () {
    late MockAuthRepository mockAuthRepository;
    late MockAddressRepository mockAddressRepository;
    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockAddressRepository = MockAddressRepository();
    });
    test('initialized with loading state', () {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      final controller = CheckoutScreenController(
        authRepository: mockAuthRepository,
        addressRepository: mockAddressRepository,
      );
      expect(controller.debugState, isA<AsyncLoading>());
    });

    test('no user -> register page', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      final controller = CheckoutScreenController(
        authRepository: mockAuthRepository,
        addressRepository: mockAddressRepository,
      );
      await controller.updateSubRoute();
      expect(controller.debugState, const AsyncData(CheckoutSubRoute.register));
    });

    test('user with no address -> address page', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(fakeUser);
      when(() => mockAddressRepository.fetchAddress(fakeUserId))
          .thenAnswer((invocation) => Future.value(null));
      final controller = CheckoutScreenController(
        authRepository: mockAuthRepository,
        addressRepository: mockAddressRepository,
      );
      await controller.updateSubRoute();
      expect(controller.debugState, const AsyncData(CheckoutSubRoute.address));
    });

    test('user with address -> payment page', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(fakeUser);
      when(() => mockAddressRepository.fetchAddress(fakeUserId))
          .thenAnswer((invocation) => Future.value(Address(
                address: 'abc',
                city: 'abc',
                country: 'abc',
                postalCode: 'abc',
                state: 'abc',
              )));
      final controller = CheckoutScreenController(
        authRepository: mockAuthRepository,
        addressRepository: mockAddressRepository,
      );
      await controller.updateSubRoute();
      expect(controller.debugState, const AsyncData(CheckoutSubRoute.payment));
    });
  });
}
