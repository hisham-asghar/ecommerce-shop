import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/application/products_search_service.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/presentation/products_list/product_card.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/domain/product.dart';

/// A widget that displays the list of products that match the search query.
class ProductsGrid extends ConsumerWidget {
  const ProductsGrid({Key? key, required this.productSelectedRoute})
      : super(key: key);
  // ! Remove this argument for the Foundations course (it is only needed to
  // ! decide which route to take depending on the parent page if there is an
  // ! admin section).
  final String productSelectedRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final productsValue = ref.watch(productsListProvider);
    final productsValue = ref.watch(productsSearchResultsProvider);
    return AsyncValueWidget<Result<String, List<Product>>>(
      value: productsValue,
      data: (result) => result.when(
        (error) => Center(
          child: ErrorMessageWidget(error),
        ),
        (products) => products.isEmpty
            ? Center(
                child: Text(
                  context.loc.noProductsFound,
                  style: Theme.of(context).textTheme.headline4,
                ),
              )
            : ProductsLayoutGrid(
                itemCount: products.length,
                itemBuilder: (_, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onPressed: () => context.goNamed(
                      productSelectedRoute,
                      params: {'id': product.id},
                    ),
                  );
                },
              ),
      ),
    );
  }
}

/// Grid widget with content-sized items.
/// See: https://codewithandrea.com/articles/flutter-layout-grid-content-sized-items/
class ProductsLayoutGrid extends StatelessWidget {
  const ProductsLayoutGrid({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  /// Total number of items to display.
  final int itemCount;

  /// Function used to build a widget for a given index in the grid.
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    // use a LayoutBuilder to determine the crossAxisCount
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      // 1 column for width < 500px
      // then add one more column for each 250px
      final crossAxisCount = max(1, width ~/ 250);
      // once the crossAxisCount is known, calculate the column and row sizes
      // set some flexible track sizes based on the crossAxisCount with 1.fr
      final columnSizes = List.generate(crossAxisCount, (_) => 1.fr);
      final numRows = (itemCount / crossAxisCount).ceil();
      // set all the row sizes to auto (self-sizing height)
      final rowSizes = List.generate(numRows, (_) => auto);
      return LayoutGrid(
        columnSizes: columnSizes,
        rowSizes: rowSizes,
        rowGap: Sizes.p24, // equivalent to mainAxisSpacing
        columnGap: Sizes.p24, // equivalent to crossAxisSpacing
        children: [
          // render all the items with automatic child placement
          for (var i = 0; i < itemCount; i++) itemBuilder(context, i),
        ],
      );
    });
  }
}
