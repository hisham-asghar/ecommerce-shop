import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/custom_image.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/item_quantity_selector.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/item.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/presentation/shopping_cart/shopping_cart_item_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/application/products_service.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/domain/product.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/currency_formatter.dart';

/// Shows a shopping cart item (or loading/error UI if needed)
class ShoppingCartItem extends ConsumerWidget {
  const ShoppingCartItem({
    Key? key,
    required this.item,
    required this.itemIndex,
    this.isEditable = true,
  }) : super(key: key);
  final Item item;
  final int itemIndex;

  /// if true, an [ItemQuantitySelector] and a delete button will be shown
  /// if false, the quantity will be shown as a read-only label (used in the
  /// [PaymentPage])
  final bool isEditable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(productProvider(item.productId));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: AsyncValueWidget<Product?>(
            value: productValue,
            data: (product) => ShoppingCartItemContents(
              // * safe to use use ! operator, assuming that the productId
              // * for a given item always points to an existing product
              product: product!,
              item: item,
              itemIndex: itemIndex,
              isEditable: isEditable,
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows a shopping cart item for a given product
class ShoppingCartItemContents extends ConsumerWidget {
  const ShoppingCartItemContents({
    Key? key,
    required this.product,
    required this.item,
    required this.itemIndex,
    required this.isEditable,
  }) : super(key: key);
  final Product product;
  final Item item;
  final int itemIndex;
  final bool isEditable;

  static Key deleteKey(int index) => Key('delete-$index');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // error handling
    ref.listen<VoidAsyncValue>(
      shoppingCartItemControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(shoppingCartItemControllerProvider);
    final priceFormatted =
        ref.watch(currencyFormatterProvider).format(product.price);
    return ResponsiveTwoColumnLayout(
      startFlex: 1,
      endFlex: 2,
      breakpoint: 320,
      startContent: CustomImage(imageUrl: product.imageUrl),
      spacing: Sizes.p24,
      endContent: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(product.title, style: Theme.of(context).textTheme.headline5),
          gapH24,
          Text(priceFormatted, style: Theme.of(context).textTheme.headline5),
          gapH24,
          isEditable
              // show the quantity selector and a delete button
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ItemQuantitySelector(
                      quantity: item.quantity,
                      maxQuantity: min(product.availableQuantity, 10),
                      itemIndex: itemIndex,
                      onChanged: state.isLoading
                          ? null
                          : (quantity) => ref
                              .read(shoppingCartItemControllerProvider.notifier)
                              .updateQuantity(item, quantity),
                    ),
                    IconButton(
                      key: deleteKey(itemIndex),
                      icon: Icon(Icons.delete, color: Colors.red[700]),
                      onPressed: state.isLoading
                          ? null
                          : () => ref
                              .read(shoppingCartItemControllerProvider.notifier)
                              .deleteItem(item),
                    ),
                    const Spacer(),
                  ],
                )
              // else, show the quantity as a read-only label
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
                  child: Text(
                    context.loc.quantityValue(item.quantity),
                  ),
                ),
        ],
      ),
    );
  }
}
