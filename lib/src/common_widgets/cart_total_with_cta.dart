import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/cart_total_text.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';

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
        const Gap(Sizes.p16),
        ctaBuilder(context),
        const Gap(Sizes.p8),
      ],
    );
  }
}
