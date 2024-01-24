import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/cart_total_text.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/card_payment_screen_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

class CardPaymentScreen extends ConsumerStatefulWidget {
  const CardPaymentScreen({Key? key}) : super(key: key);

  @override
  _CardPaymentScreenState createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends ConsumerState<CardPaymentScreen> {
  CardFieldInputDetails? _card;
  bool? _saveCard = false;

  Future<void> _pay() async {
    final controller = ref.read(cardPaymentScreenControllerProvider.notifier);
    final success = await controller.pay(_saveCard ?? false);
    if (success) {
      // TODO: use go_router to figure out where to go
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // error handling
    ref.listen<VoidAsyncValue>(
      cardPaymentScreenControllerProvider,
      // TODO: Custom error handling
      (_, state) => state.showSnackBarOnError(context),
    );
    final paymentState = ref.watch(cardPaymentScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Card Payment')),
      body: Center(
        child: SizedBox(
          width: FormFactor.tablet,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CartTotalText(),
                gapH24,
                CardField(
                  onCardChanged: (card) {
                    setState(() {
                      _card = card;
                    });
                  },
                ),
                gapH8,
                Text(
                  '[DEV build] Use 4242 4242 4242 4242 for testing',
                  style: Theme.of(context).textTheme.caption,
                ),
                gapH24,
                CheckboxListTile(
                  value: _saveCard,
                  onChanged: (value) {
                    setState(() {
                      _saveCard = value;
                    });
                  },
                  title: const Text('Save card during payment'),
                ),
                gapH24,
                PrimaryButton(
                  isLoading: paymentState.isLoading,
                  onPressed: !paymentState.isLoading && _card?.complete == true
                      ? _pay
                      : null,
                  text: 'Pay',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
