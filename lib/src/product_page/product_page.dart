import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/home/home_app_bar.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/product_page/add_to_cart_box.dart';

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
      appBar: HomeAppBar(),
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
    // TODO: Responsive layout
    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Image.network(product.imageUrl),
          ),
          SizedBox(width: Sizes.p24),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(product.title,
                    style: Theme.of(context).textTheme.headline5),
                SizedBox(height: Sizes.p24),
                Text('Price: ${product.price}',
                    style: Theme.of(context).textTheme.subtitle1),
                SizedBox(height: Sizes.p24),
                Text(product.description),
                SizedBox(height: Sizes.p24),
                AddToCartBox(product: product),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
