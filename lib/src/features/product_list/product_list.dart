import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_list/product_card.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/product_page.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

class ProductList extends StatelessWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // TODO: Carousel?
        SliverPadding(
          padding: const EdgeInsets.all(Sizes.p16),
          sliver: SliverToBoxAdapter(
            child: Text('Latest Products',
                style: Theme.of(context).textTheme.headline4),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: Sizes.p16),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(Sizes.p16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = kTestProducts[index];
                return ProductCard(
                  product: product,
                  onPressed: () => Navigator.of(context).push(
                    ProductPage.route(product),
                  ),
                );
              },
              childCount: kTestProducts.length,
            ),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              // TODO: Aspect ratio / axis extent calculation
              mainAxisExtent: 450,
              childAspectRatio: 0.8,
              mainAxisSpacing: Sizes.p32,
              crossAxisSpacing: Sizes.p32,
            ),
          ),
        ),
      ],
    );
  }
}
