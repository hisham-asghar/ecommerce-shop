import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/payment_button_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

import '../../../../mocks.dart';

void main() {
  final localizations = AppLocalizationsEn();
  test('payment successful', () async {
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.payWithPaymentSheet())
        .thenAnswer((_) async => Future.value());
    final controller = PaymentButtonController(
      localizations: localizations,
      checkoutService: mockCheckoutService,
    );
    await controller.pay();
    verify(() => mockCheckoutService.payWithPaymentSheet()).called(1);
    expect(controller.debugState, const VoidAsyncValue.loading());
  });

  test('payment failure (Stripe)', () async {
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.payWithPaymentSheet()).thenThrow(
      const StripeException(
        error: LocalizedErrorMessage(
          code: FailureCode.Failed,
          localizedMessage: 'Payment failed',
        ),
      ),
    );
    final controller = PaymentButtonController(
      localizations: localizations,
      checkoutService: mockCheckoutService,
    );
    expect(
        controller.stream,
        emitsInOrder([
          const VoidAsyncValue.loading(),
          const VoidAsyncValue.error('Payment failed'),
          const VoidAsyncValue.data(null),
        ]));
    await controller.pay();
    verify(() => mockCheckoutService.payWithPaymentSheet()).called(1);
  });

  test('payment canceled (Stripe)', () async {
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.payWithPaymentSheet()).thenThrow(
      const StripeException(
        error: LocalizedErrorMessage(
          code: FailureCode.Canceled,
          localizedMessage: 'Payment failed',
        ),
      ),
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

  test('payment failure (generic)', () async {
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.payWithPaymentSheet()).thenThrow(
      Exception('Something went wrong'),
    );
    final controller = PaymentButtonController(
      localizations: localizations,
      checkoutService: mockCheckoutService,
    );
    expect(
        controller.stream,
        emitsInOrder([
          const VoidAsyncValue.loading(),
          const VoidAsyncValue.error('Could not place order'),
          const VoidAsyncValue.data(null),
        ]));
    await controller.pay();
    verify(() => mockCheckoutService.payWithPaymentSheet()).called(1);
  });
}
