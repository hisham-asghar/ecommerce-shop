import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_assets.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/product_list/product_card.dart';

class ProductList extends StatelessWidget {
  ProductList({Key? key}) : super(key: key);

  final products = [
    ProductCardData(
      imageUrl: AppAssets.sonyPlaystation4,
      title: 'Sony Playstation 4 Pro White Version',
      price: 399,
    ),
    ProductCardData(
      imageUrl: AppAssets.amazonEchoDot3,
      title: 'Amazon Echo Dot 3rd Generation',
      price: 29,
    ),
    ProductCardData(
      imageUrl: AppAssets.canonEos80d,
      title: 'Cannon EOS 80D DSLR Camera',
      price: 929,
    ),
    ProductCardData(
      imageUrl: AppAssets.iPhone11Pro,
      title: 'iPhone 11 Pro 256GB Memory',
      price: 599,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: Make it all scrollable inside a sliver
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Latest Products', style: Theme.of(context).textTheme.headline4),
        SizedBox(height: Sizes.p32),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 0.8,
              mainAxisSpacing: Sizes.p32,
              crossAxisSpacing: Sizes.p32,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                data: products[index],
              );
            },
          ),
        )
      ],
    );
  }
}
