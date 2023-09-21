import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/features/home/home_app_bar.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_list/product_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      // TODO: Carousel
      body: ProductList(),
    );
  }
}
