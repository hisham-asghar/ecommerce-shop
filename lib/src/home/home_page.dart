import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/product_list/product_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO: custom app bar
        title: Text('MyShop'),
      ),
      // TODO: Carousel
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: ProductList(),
      ),
    );
  }
}
