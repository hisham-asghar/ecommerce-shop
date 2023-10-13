import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/routing.dart';

enum PopupMenuOption {
  orders,
  account,
  admin,
}

class MoreMenuButton extends ConsumerWidget {
  const MoreMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
//    final authStateValue = ref.watch(authStateChangesProvider);
    return PopupMenuButton(
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
    );
  }
}
