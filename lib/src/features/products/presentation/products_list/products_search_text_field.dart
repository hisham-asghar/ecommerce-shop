import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/application/products_search_service.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';

/// Search field used to filter products by name
class ProductsSearchTextField extends ConsumerStatefulWidget {
  const ProductsSearchTextField({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductsSearchTextField> createState() =>
      _ProductsSearchTextFieldState();
}

class _ProductsSearchTextFieldState
    extends ConsumerState<ProductsSearchTextField> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // See this article for more info about how to use [ValueListenableBuilder]
    // with TextField:
    // https://codewithandrea.com/articles/flutter-text-field-form-validation/
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        return TextField(
          controller: _controller,
          autofocus: false,
          style: Theme.of(context).textTheme.headline6,
          decoration: InputDecoration(
            hintText: context.loc.searchProducts,
            icon: const Icon(Icons.search),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _controller.clear();
                      ref.read(productsSearchServiceProvider).search('');
                    },
                    icon: const Icon(Icons.clear),
                  )
                : null,
          ),
          onChanged: (text) =>
              ref.read(productsSearchServiceProvider).search(text),
        );
      },
    );
  }
}
