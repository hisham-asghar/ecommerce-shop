import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/routing.dart';

enum PopupMenuOption {
  orders,
  account,
  admin,
}

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
        // TODO: Move to separate widget?
        PopupMenuButton(
          initialValue: PopupMenuOption.orders,
          onSelected: (option) {
            final routerDelegate = ref.read(routerDelegateProvider);
            switch (option) {
              case PopupMenuOption.orders:
                routerDelegate.openOrdersList();
                break;
              case PopupMenuOption.account:
                routerDelegate.openAccount();
                break;
              case PopupMenuOption.admin:
                routerDelegate.openAdmin();
                break;
              default:
                print('Unimplemented');
            }
          },
          itemBuilder: (_) {
            return <PopupMenuEntry<PopupMenuOption>>[
              const PopupMenuItem(
                child: Text('Orders'),
                value: PopupMenuOption.orders,
              ),
              const PopupMenuItem(
                child: Text('Account'),
                value: PopupMenuOption.account,
              ),
              const PopupMenuItem(
                child: Text('Admin'),
                value: PopupMenuOption.admin,
              ),
            ];
          },
          // TODO: Find right icon
          icon: const Icon(Icons.more_vert),
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60.0);
}
