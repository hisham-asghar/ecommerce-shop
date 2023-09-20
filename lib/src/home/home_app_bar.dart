import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/shopping_cart/shopping_cart.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My Shop'),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          // TODO: Items storage
          onPressed: () => Navigator.of(context).push(ShoppingCartPage.route()),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60.0);
}
