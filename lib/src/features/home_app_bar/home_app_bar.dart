import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/action_text_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/home_app_bar/more_menu_button.dart';
import 'package:my_shop_ecommerce_flutter/src/features/home_app_bar/shopping_cart_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';

class HomeAppBar extends ConsumerWidget with PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final isAdminUser = ref.watch(isAdminUserProvider).value ?? false;
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < FormFactor.tablet) {
      return AppBar(
        title: const Text('My Shop'),
        actions: [
          const ShoppingCartIcon(),
          MoreMenuButton(user: user, isAdminUser: isAdminUser),
        ],
      );
    } else {
      return AppBar(
        title: const Text('My Shop'),
        actions: [
          const ShoppingCartIcon(),
          if (user != null) ...[
            ActionTextButton(
              key: MoreMenuButton.ordersKey,
              text: 'Orders',
              onPressed: () => context.pushNamed(AppRoute.orders.name),
            ),
            ActionTextButton(
              key: MoreMenuButton.accountKey,
              text: 'Account',
              onPressed: () => context.pushNamed(AppRoute.account.name),
            ),
            // only show this if user has admin custom claim
            if (isAdminUser == true)
              ActionTextButton(
                key: MoreMenuButton.adminKey,
                text: 'Admin',
                onPressed: () => context.pushNamed(AppRoute.admin.name),
              ),
          ] else
            ActionTextButton(
              key: MoreMenuButton.signInKey,
              text: 'Sign in',
              onPressed: () => context.pushNamed(AppRoute.signIn.name),
            )
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
