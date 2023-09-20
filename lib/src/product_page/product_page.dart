import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/product_list/product_data.dart';
import 'package:my_shop_ecommerce_flutter/src/product_page/add_to_cart_box.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key, required this.data}) : super(key: key);
  final ProductData data;

  // TODO: named routes
  static Route route(ProductData data) {
    return MaterialPageRoute(
      builder: (_) => ProductPage(data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ProductPageContents(data: data),
    );
  }
}

class ProductPageContents extends StatelessWidget {
  const ProductPageContents({Key? key, required this.data}) : super(key: key);
  final ProductData data;
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
            child: Image.network(data.imageUrl),
          ),
          SizedBox(width: Sizes.p24),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(data.title, style: Theme.of(context).textTheme.headline5),
                SizedBox(height: Sizes.p24),
                Text('Price: ${data.price}',
                    style: Theme.of(context).textTheme.subtitle1),
                SizedBox(height: Sizes.p24),
                Text(data.description),
                SizedBox(height: Sizes.p24),
                AddToCartBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
