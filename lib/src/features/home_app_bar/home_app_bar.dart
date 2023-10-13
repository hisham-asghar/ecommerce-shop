import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/features/home_app_bar/more_menu_button.dart';
import 'package:my_shop_ecommerce_flutter/src/features/home_app_bar/shopping_cart_icon.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My Shop'),
      actions: const [
        ShoppingCartIcon(),
        MoreMenuButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
