import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';

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
        // TODO: should these use goNamed?
        switch (option) {
          case PopupMenuOption.signIn:
            context.pushNamed(AppRoute.signIn.name);
            break;
          case PopupMenuOption.orders:
            context.pushNamed(AppRoute.orders.name);
            break;
          case PopupMenuOption.account:
            context.pushNamed(AppRoute.account.name);
            break;
          case PopupMenuOption.admin:
            context.pushNamed(AppRoute.admin.name);
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
