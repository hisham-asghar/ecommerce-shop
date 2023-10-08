import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/order_payment_options.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/products_repository.dart';

class PaymentPage extends ConsumerWidget {
  PaymentPage({Key? key}) : super(key: key);

  // Adding an explicit ScrollController as a fix for:
  // > The provided ScrollController is currently attached to more than one ScrollPosition
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsRepository = ref.watch(productsRepositoryProvider);
    final itemsValue = ref.watch(cartItemsProvider);
    return itemsValue.when(
      data: (items) => CustomScrollView(
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
                    // make item non editable so that user can't empty cart completely
                    isEditable: false,
                  );
                },
                childCount: items.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: OrderPaymentOptions(
                total: productsRepository.calculateTotal(items)),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text(e.toString())),
    );
  }
}
