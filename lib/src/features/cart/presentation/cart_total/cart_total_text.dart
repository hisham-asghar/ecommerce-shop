import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/application/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/currency_formatter.dart';

/// Text widget for showing the total price of the cart
class CartTotalText extends ConsumerWidget {
  const CartTotalText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartTotal = ref.watch(cartTotalProvider);
    final totalFormatted =
        ref.watch(currencyFormatterProvider).format(cartTotal);
    return Text(
      context.loc.totalValue(totalFormatted),
      style: Theme.of(context).textTheme.headline5,
      textAlign: TextAlign.center,
    );
  }
}
