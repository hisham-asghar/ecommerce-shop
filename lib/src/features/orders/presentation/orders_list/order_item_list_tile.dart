import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/custom_image.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/item.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/application/products_service.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/domain/product.dart';

/// Shows an individual order item, including price and quantity.
class OrderItemListTile extends ConsumerWidget {
  const OrderItemListTile({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(productProvider(item.productId));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
      child: AsyncValueWidget<Product?>(
        value: productValue,
        data: (product) => Row(
          children: [
            Flexible(
              flex: 1,
              child: CustomImage(imageUrl: product!.imageUrl),
            ),
            gapW8,
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title),
                  gapH12,
                  Text(
                    context.loc.quantityValue(item.quantity),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
