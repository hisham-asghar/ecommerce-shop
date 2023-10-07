import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/home_app_bar.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_list/product_card.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/routing.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              const SliverPadding(
                padding: EdgeInsets.all(Sizes.p16),
                sliver: ProductsGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductsGrid extends ConsumerWidget {
  const ProductsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsValue = ref.watch(productsProvider);
    return productsValue.when(
      data: (products) => SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onPressed: () =>
                  ref.read(routerDelegateProvider).selectProduct(product),
            );
          },
          childCount: products.length,
        ),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 350,
          // TODO: Aspect ratio / axis extent calculation
          mainAxisExtent: 450,
          childAspectRatio: 0.8,
          mainAxisSpacing: Sizes.p24,
          crossAxisSpacing: Sizes.p24,
        ),
      ),
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => SliverToBoxAdapter(
        child: Center(child: Text(e.toString())),
      ),
    );
  }
}
