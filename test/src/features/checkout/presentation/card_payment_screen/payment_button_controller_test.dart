import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:my_shop_ecommerce_flutter/src/exceptions/app_exception.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/presentation/payment_page/payment_button_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

import '../../../../../mocks.dart';

void main() {
  final localizations = AppLocalizationsEn();
  test('payment successful', () async {
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.payWithPaymentSheet())
        .thenAnswer((_) async => Future.value(const Success(null)));
    final controller = PaymentButtonController(
      localizations: localizations,
      checkoutService: mockCheckoutService,
    );
    await controller.pay();
    verify(() => mockCheckoutService.payWithPaymentSheet()).called(1);
    expect(controller.debugState, const VoidAsyncValue.data(null));
  });

  test('payment failure (Stripe)', () async {
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.payWithPaymentSheet()).thenAnswer(
      (_) async => Future.value(const Error(AppException.paymentFailed(''))),
    );
    final controller = PaymentButtonController(
      localizations: localizations,
      checkoutService: mockCheckoutService,
    );
    expect(
        controller.stream,
        emitsInOrder([
          const VoidAsyncValue.loading(),
          const VoidAsyncValue.error(''),
        ]));
    await controller.pay();
    verify(() => mockCheckoutService.payWithPaymentSheet()).called(1);
  });

  test('payment canceled (Stripe)', () async {
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.payWithPaymentSheet()).thenAnswer(
      (_) async => Future.value(const Error(AppException.paymentCanceled(''))),
    );
    final controller = PaymentButtonController(
      localizations: localizations,
      checkoutService: mockCheckoutService,
    );
    expect(
        controller.stream,
        emitsInOrder([
          const VoidAsyncValue.loading(),
          const VoidAsyncValue.data(null),
        ]));
    await controller.pay();
    verify(() => mockCheckoutService.payWithPaymentSheet()).called(1);
  });

  test('payment failure (functions error)', () async {
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.payWithPaymentSheet()).thenAnswer(
      (_) async => Future.value(const Error(AppException.functions(''))),
    );
    final controller = PaymentButtonController(
      localizations: localizations,
      checkoutService: mockCheckoutService,
    );
    expect(
        controller.stream,
        emitsInOrder([
          const VoidAsyncValue.loading(),
          const VoidAsyncValue.error(''),
        ]));
    await controller.pay();
    verify(() => mockCheckoutService.payWithPaymentSheet()).called(1);
  });

  test('payment failure (other error)', () async {
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.payWithPaymentSheet()).thenAnswer(
      (_) async => Future.value(
          const Error(AppException.unknown('123', StackTrace.empty))),
    );
    final controller = PaymentButtonController(
      localizations: localizations,
      checkoutService: mockCheckoutService,
    );
    expect(
        controller.stream,
        emitsInOrder([
          const VoidAsyncValue.loading(),
          VoidAsyncValue.error(localizations.anErrorOccurred),
        ]));
    await controller.pay();
    verify(() => mockCheckoutService.payWithPaymentSheet()).called(1);
  });
}
