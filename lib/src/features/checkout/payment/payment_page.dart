import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/decorated_box_with_shadow.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/payment_button.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_total.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/currency_formatter.dart';

class PaymentPage extends ConsumerWidget {
  PaymentPage({Key? key}) : super(key: key);

  // Adding an explicit ScrollController as a fix for:
  // > The provided ScrollController is currently attached to more than one ScrollPosition
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: back to home page once a new order has been created (cart is empty)
    final itemsValue = ref.watch(cartItemsListProvider);
    return AsyncValueWidget<List<Item>>(
      value: itemsValue,
      data: (items) => Column(
        children: [
          Expanded(
            // TODO: Should this be ScrollablePage?
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(height: Sizes.p16),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = items[index];
                        return ShoppingCartItem(
                          item: item,
                          itemIndex: index,
                          // make item non editable so that user can't empty cart completely
                          isEditable: false,
                        );
                      },
                      childCount: items.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // TODO: Test this on desktop
          const DecoratedBoxWithShadow(
            child: PaymentPagePay(),
          )
        ],
      ),
    );
  }
}

class PaymentPagePay extends ConsumerWidget {
  const PaymentPagePay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartTotalValue = ref.watch(cartTotalProvider);
    return AsyncValueWidget<CartTotal>(
      value: cartTotalValue,
      data: (cartTotal) {
        final totalFormatted =
            ref.watch(currencyFormatterProvider).format(cartTotal.total);
        return Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Order total: $totalFormatted',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.p24),
              const PaymentButton(),
            ],
          ),
        );
      },
    );
  }
}
