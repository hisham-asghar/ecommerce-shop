import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_list/product_card.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/products_repository.dart';

class ProductsGrid extends ConsumerWidget {
  const ProductsGrid({Key? key, required this.onProductSelected})
      : super(key: key);
  final void Function(Product) onProductSelected;

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
              onPressed: () => onProductSelected(product),
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
