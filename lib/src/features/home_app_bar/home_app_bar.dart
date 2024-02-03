import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/action_text_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/home_app_bar/more_menu_button.dart';
import 'package:my_shop_ecommerce_flutter/src/features/home_app_bar/shopping_cart_icon.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';

/// Custom [AppBar] widget that is reused by the [ProductsListScreen] and
/// [ProductScreen].
/// It shows the following actions, depending on the application state:
/// - [ShoppingCartIcon]
/// - Orders button
/// - Account or Sign-in button
/// - Admin button (if the user is an admin)
class HomeAppBar extends ConsumerWidget with PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final isAdminUser = ref.watch(isAdminUserProvider).value ?? false;
    // * This widget is responsive.
    // * On large screen sizes, it shows all the actions in the app bar.
    // * On small screen sizes, it shows only the shopping cart icon and a
    // * [MoreMenuButton].
    // ! MediaQuery is used on the assumption that the widget takes up the full
    // ! width of the screen. If that's not the case, LayoutBuilder should be
    // ! used instead.
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < FormFactor.tablet) {
      return AppBar(
        title: Text(context.loc.appBarTitle),
        actions: [
          const ShoppingCartIcon(),
          MoreMenuButton(user: user, isAdminUser: isAdminUser),
        ],
      );
    } else {
      return AppBar(
        title: Text(context.loc.appBarTitle),
        actions: [
          const ShoppingCartIcon(),
          if (user != null) ...[
            ActionTextButton(
              key: MoreMenuButton.ordersKey,
              text: context.loc.orders,
              onPressed: () => context.pushNamed(AppRoute.orders.name),
            ),
            ActionTextButton(
              key: MoreMenuButton.accountKey,
              text: context.loc.account,
              onPressed: () => context.pushNamed(AppRoute.account.name),
            ),
            // only show this if user has admin custom claim
            if (isAdminUser == true)
              ActionTextButton(
                key: MoreMenuButton.adminKey,
                text: context.loc.admin,
                onPressed: () => context.pushNamed(AppRoute.admin.name),
              ),
          ] else
            ActionTextButton(
              key: MoreMenuButton.signInKey,
              text: context.loc.signIn,
              onPressed: () => context.pushNamed(AppRoute.signIn.name),
            )
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
