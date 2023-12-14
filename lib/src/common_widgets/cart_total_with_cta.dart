import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/currency_formatter.dart';

class CartTotalWithCTA extends ConsumerWidget {
  const CartTotalWithCTA({Key? key, required this.ctaBuilder})
      : super(key: key);
  final WidgetBuilder ctaBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartTotalValue = ref.watch(cartTotalProvider);
    return AsyncValueWidget<double>(
      value: cartTotalValue,
      data: (cartTotal) {
        final totalFormatted =
            ref.watch(currencyFormatterProvider).format(cartTotal);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Total: $totalFormatted',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.p16),
            ctaBuilder(context),
            const SizedBox(height: Sizes.p8),
          ],
        );
      },
    );
  }
}
