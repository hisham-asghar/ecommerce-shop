import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';

/// Shopping cart icon with items count badge
class ShoppingCartIcon extends ConsumerWidget {
  const ShoppingCartIcon({Key? key}) : super(key: key);

  static const shoppingCartIconKey = Key('shopping-cart');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsValue = ref.watch(cartItemsListProvider);
    final itemsCount =
        itemsValue.maybeWhen(data: (items) => items.length, orElse: () => null);
    return Stack(
      children: [
        Center(
          child: IconButton(
            key: shoppingCartIconKey,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.pushNamed(AppRoute.cart.name),
          ),
        ),
        if (itemsCount != null && itemsCount > 0)
          Positioned(
            top: Sizes.p4,
            right: Sizes.p4,
            child: ShoppingCartIconBadge(itemsCount: itemsCount),
          ),
      ],
    );
  }
}

/// Icon badge showing the items count
class ShoppingCartIconBadge extends ConsumerStatefulWidget {
  const ShoppingCartIconBadge({Key? key, required this.itemsCount})
      : super(key: key);
  final int itemsCount;

  @override
  ConsumerState<ShoppingCartIconBadge> createState() =>
      _ShoppingCartIconBadgeState();
}

class _ShoppingCartIconBadgeState extends ConsumerState<ShoppingCartIconBadge>
    with SingleTickerProviderStateMixin {
  // ! remove animation for Foundations course?
  late final _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));

  @override
  void initState() {
    super.initState();
    _animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_updateStatus);
    _animationController.dispose();
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animationController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use a provider listener to forward the animation and make the badge "bounce"
    ref.listen<AsyncValue<List<Item>>>(cartItemsListProvider, (_, itemsValue) {
      final itemsCount =
          itemsValue.maybeWhen(data: (items) => items.length, orElse: () => 0);
      if (itemsCount > 0) {
        _animationController.forward();
      }
    });

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        final sineValue = sin(pi * _animationController.value);
        return Transform.scale(
          scale: 1.0 + sineValue * 0.5,
          child: SizedBox(
            width: Sizes.p16,
            height: Sizes.p16,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                //borderRadius: BorderRadius.all(Radius.circular(Sizes.p8)),
              ),
              child: Text(
                '${widget.itemsCount}',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
