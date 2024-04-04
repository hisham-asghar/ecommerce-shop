import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/domain/app_user.dart';
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
      // three vertical dots icon (to reveal menu options)
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) {
        // show all the options based on conditional logic
        return user != null
            ? <PopupMenuEntry<PopupMenuOption>>[
                PopupMenuItem(
                  key: ordersKey,
                  child: Text(context.loc.orders),
                  value: PopupMenuOption.orders,
                ),
                PopupMenuItem(
                  key: accountKey,
                  child: Text(context.loc.account),
                  value: PopupMenuOption.account,
                ),
                // only show this if user has admin custom claim
                if (isAdminUser == true)
                  PopupMenuItem(
                    key: adminKey,
                    child: Text(context.loc.admin),
                    value: PopupMenuOption.admin,
                  ),
              ]
            : <PopupMenuEntry<PopupMenuOption>>[
                PopupMenuItem(
                  key: signInKey,
                  child: Text(context.loc.signIn),
                  value: PopupMenuOption.signIn,
                ),
              ];
      },
      onSelected: (option) {
        // push to different routes based on selected option
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
        }
      },
    );
  }
}
