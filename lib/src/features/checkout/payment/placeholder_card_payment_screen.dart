import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/scrollable_page.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/payment_button_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

// TODO: Delete this page
class PlaceholderCardPaymentScreen extends ConsumerWidget {
  const PlaceholderCardPaymentScreen({Key? key}) : super(key: key);

  void _placeOrder(BuildContext context, WidgetRef ref) async {
    final model = ref.read(paymentButtonControllerProvider.notifier);
    final order = await model.pay();
    // TODO: Use ref.listen on order data instead
    // if (order != null) {
    //   context.goNamed(AppRoute.paymentComplete.name, params: {'id': order.id});
    // }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // error handling
    ref.listen<WidgetBasicState>(
      paymentButtonControllerProvider,
      (_, state) => state.showSnackBarOnError(context),
    );
    final state = ref.watch(paymentButtonControllerProvider);
    return Scaffold(
      appBar: AppBar(),
      body: ScrollablePage(
        //padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const UnsupportedPlatformPaymentPlaceholder(),
            PrimaryButton(
              onPressed:
                  state.isLoading ? null : () => _placeOrder(context, ref),
              isLoading: state.isLoading,
              text: 'Pay',
            ),
          ],
        ),
      ),
    );
  }
}

class UnsupportedPlatformPaymentPlaceholder extends StatelessWidget {
  const UnsupportedPlatformPaymentPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p32),
      child: Column(children: const [
        Placeholder(
          fallbackHeight: 200,
        ),
        SizedBox(height: Sizes.p16),
        Text(
          'Payment not supported on platform',
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}
