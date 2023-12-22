import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/card_payment_screen_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

import '../../../../mocks.dart';

void main() {
  test('payment successful', () async {
    const saveCard = true;
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.payByCard(saveCard))
        .thenAnswer((_) async => Future.value());
    final controller =
        CardPaymentScreenController(checkoutService: mockCheckoutService);
    await controller.pay(saveCard);
    verify(() => mockCheckoutService.payByCard(saveCard)).called(1);
    expect(controller.debugState, const VoidAsyncValue.data(null));
  });

  test('payment failure (Stripe)', () async {
    const saveCard = true;
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.payByCard(saveCard)).thenThrow(
      const StripeException(
        error: LocalizedErrorMessage(
          code: FailureCode.Failed,
          localizedMessage: 'Payment failed',
        ),
      ),
    );
    final controller =
        CardPaymentScreenController(checkoutService: mockCheckoutService);
    expect(
        controller.stream,
        emitsInOrder([
          const VoidAsyncValue.loading(),
          const VoidAsyncValue.error('Payment failed'),
          const VoidAsyncValue.data(null),
        ]));
    await controller.pay(saveCard);
    verify(() => mockCheckoutService.payByCard(saveCard)).called(1);
  });

  test('payment canceled (Stripe)', () async {
    const saveCard = true;
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.payByCard(saveCard)).thenThrow(
      const StripeException(
        error: LocalizedErrorMessage(
          code: FailureCode.Canceled,
          localizedMessage: 'Payment failed',
        ),
      ),
    );
    final controller =
        CardPaymentScreenController(checkoutService: mockCheckoutService);
    expect(
        controller.stream,
        emitsInOrder([
          const VoidAsyncValue.loading(),
          const VoidAsyncValue.data(null),
        ]));
    await controller.pay(saveCard);
    verify(() => mockCheckoutService.payByCard(saveCard)).called(1);
  });

  test('payment failure (generic)', () async {
    const saveCard = true;
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.payByCard(saveCard)).thenThrow(
      Exception('Something went wrong'),
    );
    final controller =
        CardPaymentScreenController(checkoutService: mockCheckoutService);
    expect(
        controller.stream,
        emitsInOrder([
          const VoidAsyncValue.loading(),
          const VoidAsyncValue.error('Could not place order'),
          const VoidAsyncValue.data(null),
        ]));
    await controller.pay(saveCard);
    verify(() => mockCheckoutService.payByCard(saveCard)).called(1);
  });
}
