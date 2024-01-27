import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_list/products_grid.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';

class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.manageProducts),
      ),
      body: Center(
        child: SizedBox(
          width: FormFactor.desktop,
          // TODO: Make scroll-bar appear at the edge of the screen
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(Sizes.p16),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    context.loc.manageProducts,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(Sizes.p16),
                sliver: ProductsGrid(
                  productSelectedRoute: AppRoute.adminProduct.name,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            context.goNamed(AppRoute.adminProduct.name, params: {'id': 'new'}),
      ),
    );
  }
}
