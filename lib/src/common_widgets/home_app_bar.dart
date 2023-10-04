import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/routing.dart';

class HomeAppBar extends ConsumerWidget with PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('My Shop'),
      actions: [
        IconButton(
          // TODO: show item count
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => ref.read(routerDelegateProvider).openCart(),
        ),
        IconButton(
          icon: const Icon(Icons.list),
          onPressed: () => ref.read(routerDelegateProvider).openOrdersList(),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60.0);
}
