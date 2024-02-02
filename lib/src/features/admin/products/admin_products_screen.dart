import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_center.dart';
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
      body: CustomScrollView(
        slivers: [
          ResponsiveSliverCenter(
            padding: const EdgeInsets.all(Sizes.p16),
            child: Text(
              context.loc.manageProducts,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          ResponsiveSliverCenter(
            padding: const EdgeInsets.all(Sizes.p16),
            child: ProductsGrid(
              productSelectedRoute: AppRoute.adminProduct.name,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            context.goNamed(AppRoute.adminProduct.name, params: {'id': 'new'}),
      ),
    );
  }
}
