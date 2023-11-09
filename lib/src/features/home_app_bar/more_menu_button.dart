import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/routing.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth/auth_service.dart';

enum PopupMenuOption {
  signIn,
  orders,
  account,
  admin,
}

class MoreMenuButton extends ConsumerWidget {
  const MoreMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChangesValue = ref.watch(authStateChangesProvider);
    final user = authStateChangesValue.asData?.value;
    final isAdminUserValue = ref.watch(isAdminUserProvider);
    final isAdminUser = isAdminUserValue.asData?.value;
    return PopupMenuButton(
      onSelected: (option) {
        final routerDelegate = ref.read(routerDelegateProvider);
        switch (option) {
          case PopupMenuOption.signIn:
            routerDelegate.openSignIn();
            break;
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
        return user != null
            ? <PopupMenuEntry<PopupMenuOption>>[
                const PopupMenuItem(
                  child: Text('Orders'),
                  value: PopupMenuOption.orders,
                ),
                const PopupMenuItem(
                  child: Text('Account'),
                  value: PopupMenuOption.account,
                ),
                // only show this if user has admin custom claim
                if (isAdminUser == true)
                  const PopupMenuItem(
                    child: Text('Admin'),
                    value: PopupMenuOption.admin,
                  ),
              ]
            : <PopupMenuEntry<PopupMenuOption>>[
                const PopupMenuItem(
                  child: Text('Sign In'),
                  value: PopupMenuOption.signIn,
                ),
              ];
      },
      // TODO: Find right icon
      icon: const Icon(Icons.more_vert),
    );
  }
}
