import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';

enum PopupMenuOption {
  signIn,
  orders,
  account,
  admin,
}

class MoreMenuButton extends StatelessWidget {
  const MoreMenuButton({Key? key, this.user, this.isAdminUser = false})
      : super(key: key);
  final AppUser? user;
  final bool isAdminUser;

  static const signInKey = Key('menuSignIn');
  static const ordersKey = Key('menuOrders');
  static const accountKey = Key('menuAccount');
  static const adminKey = Key('menuAdmin');

  @override
  Widget build(BuildContext context) {
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
            debugPrint('Unimplemented');
        }
      },
      itemBuilder: (_) {
        return user != null
            ? <PopupMenuEntry<PopupMenuOption>>[
                const PopupMenuItem(
                  key: ordersKey,
                  child: Text('Orders'),
                  value: PopupMenuOption.orders,
                ),
                const PopupMenuItem(
                  key: accountKey,
                  child: Text('Account'),
                  value: PopupMenuOption.account,
                ),
                // only show this if user has admin custom claim
                if (isAdminUser == true)
                  const PopupMenuItem(
                    key: adminKey,
                    child: Text('Admin'),
                    value: PopupMenuOption.admin,
                  ),
              ]
            : <PopupMenuEntry<PopupMenuOption>>[
                const PopupMenuItem(
                  key: signInKey,
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
