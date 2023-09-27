import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        PrimaryButton(
          text: 'Pay by card',
        ),
      ],
    );
  }
}
