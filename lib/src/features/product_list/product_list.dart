import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/centered_box.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/preview_notice.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/home_app_bar/home_app_bar.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_list/products_grid.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_list/products_search_text_field.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_dismissOnScreenKeyboard);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_dismissOnScreenKeyboard);
    super.dispose();
  }

  // When the search text field gets the focus, the keyboard appears on mobile.
  // This method is used to dismiss the keyboard when the user scrolls.
  void _dismissOnScreenKeyboard() {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: PreviewNotice(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const CenteredSliverToBoxAdapter(
              padding: EdgeInsets.all(Sizes.p16),
              child: ProductsSearchTextField(),
              // child: Text(
              //   context.loc.latestProducts,
              //   style: Theme.of(context).textTheme.headline4,
              // ),
            ),
            CenteredSliverToBoxAdapter(
              padding: const EdgeInsets.all(Sizes.p16),
              child: ProductsGrid(
                productSelectedRoute: AppRoute.product.name,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
