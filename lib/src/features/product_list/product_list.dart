import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/home_app_bar/home_app_bar.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_list/products_grid.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Center(
        child: SizedBox(
          width: FormFactor.desktop,
          // TODO: Make scroll-bar appear at the edge of the screen
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(Sizes.p16),
                sliver: SliverToBoxAdapter(
                  child: Text('Latest Products',
                      style: Theme.of(context).textTheme.headline4),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(Sizes.p16),
                sliver: ProductsGrid(
                  onProductSelected: (product) => context.goNamed(
                      AppRoute.product.name,
                      params: {'id': product.id}),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
