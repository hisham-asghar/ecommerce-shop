import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_assets.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/product_list/product_card.dart';
import 'package:my_shop_ecommerce_flutter/src/product_list/product_data.dart';
import 'package:my_shop_ecommerce_flutter/src/product_page/product_page.dart';

class ProductList extends StatelessWidget {
  ProductList({Key? key}) : super(key: key);

  static final faker = Faker();
  final products = [
    ProductData(
      imageUrl: AppAssets.sonyPlaystation4,
      title: 'Sony Playstation 4 Pro White Version',
      description: faker.lorem.sentence(),
      price: 399,
    ),
    ProductData(
      imageUrl: AppAssets.amazonEchoDot3,
      title: 'Amazon Echo Dot 3rd Generation',
      description: faker.lorem.sentence(),
      price: 29,
    ),
    ProductData(
      imageUrl: AppAssets.canonEos80d,
      title: 'Cannon EOS 80D DSLR Camera',
      description: faker.lorem.sentence(),
      price: 929,
    ),
    ProductData(
      imageUrl: AppAssets.iPhone11Pro,
      title: 'iPhone 11 Pro 256GB Memory',
      description: faker.lorem.sentence(),
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
              final data = products[index];
              return ProductCard(
                data: data,
                onPressed: () => Navigator.of(context).push(
                  ProductPage.route(data),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
