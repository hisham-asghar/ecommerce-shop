import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/item_quantity_selector.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cart_repository.dart';

class AddToCartWidget extends ConsumerStatefulWidget {
  const AddToCartWidget({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  ConsumerState<AddToCartWidget> createState() => _AddToCartBoxState();
}

class _AddToCartBoxState extends ConsumerState<AddToCartWidget> {
  var _quantity = 1;

  void _addToCart() {
    final item = Item(
      productId: widget.product.id,
      quantity: _quantity,
    );
    ref.read(cartRepositoryProvider).addItem(item);
    // TODO: Restore
    //ScaffoldMessenger.of(context)
    //    .showSnackBar(const SnackBar(content: Text('Added to cart')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Quantity:'),
            ItemQuantitySelector(
              quantity: _quantity,
              maxQuantity: min(widget.product.availableQuantity, 10),
              onChanged: (quantity) {
                setState(() => _quantity = quantity);
              },
            ),
          ],
        ),
        const SizedBox(height: Sizes.p8),
        const Divider(),
        const SizedBox(height: Sizes.p8),
        PrimaryButton(
          onPressed: widget.product.availableQuantity > 0 ? _addToCart : null,
          text: widget.product.availableQuantity > 0
              ? 'Add to Cart'
              : 'Out of Stock',
        ),
      ],
    );
  }
}
