import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/cart_total_with_cta.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/centered_box.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/decorated_box_with_shadow.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';

class ShoppingCartItemsBuilder extends ConsumerWidget {
  const ShoppingCartItemsBuilder({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.ctaBuilder,
  }) : super(key: key);
  final List<Item> items;
  final Widget Function(BuildContext, Item, int) itemBuilder;
  final WidgetBuilder ctaBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.loc.shoppingCartEmpty,
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              gapH32,
              PrimaryButton(
                text: context.loc.goBack,
                onPressed: () {
                  context.goNamed(AppRoute.home.name);
                },
              ),
            ],
          ),
        ),
      );
    }
    final screenWidth = MediaQuery.of(context).size.width;
    // wide layouts
    if (screenWidth >= FormFactor.tablet) {
      return CenteredBox(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              // TODO: Hide scrollbar
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = items[index];
                          return itemBuilder(context, item, index);
                        },
                        childCount: items.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            gapW16,
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                child: CartTotalWithCTA(ctaBuilder: ctaBuilder),
              ),
            )
          ],
        ),
      );
    } else {
      // narrow layouts
      return Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = items[index];
                        return itemBuilder(context, item, index);
                      },
                      childCount: items.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
          DecoratedBoxWithShadow(
            child: CartTotalWithCTA(ctaBuilder: ctaBuilder),
          ),
        ],
      );
    }
  }
}
