import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/presentation/cart_total/cart_total_text.dart';

/// Widget for showing the shopping cart total with a checkout button
class CartTotalWithCTA extends StatelessWidget {
  const CartTotalWithCTA({Key? key, required this.ctaBuilder})
      : super(key: key);
  final WidgetBuilder ctaBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CartTotalText(),
        gapH8,
        ctaBuilder(context),
        gapH8,
      ],
    );
  }
}
