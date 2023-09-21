import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/home/home_app_bar.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart_box.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key, required this.product}) : super(key: key);
  final Product product;

  // TODO: named routes
  static Route route(Product product) {
    return MaterialPageRoute(
      builder: (_) => ProductPage(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: ProductPageContents(product: product),
    );
  }
}

class ProductPageContents extends StatelessWidget {
  const ProductPageContents({Key? key, required this.product})
      : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return ResponsiveTwoColumnLayout(
      padding: const EdgeInsets.all(Sizes.p16),
      startContent: Image.network(product.imageUrl),
      spacing: Sizes.p24,
      endContent: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(product.title, style: Theme.of(context).textTheme.headline5),
          const SizedBox(height: Sizes.p24),
          Text('Price: ${product.price}',
              style: Theme.of(context).textTheme.subtitle1),
          const SizedBox(height: Sizes.p24),
          Text(product.description),
          const SizedBox(height: Sizes.p24),
          AddToCartBox(product: product),
        ],
      ),
    );
  }
}
