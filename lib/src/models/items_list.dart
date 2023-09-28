import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

class ItemsList {
  ItemsList(this.items);
  final List<Item> items;

  double total() => items.isEmpty
      ? 0.0
      : items
          // first extract quantity * price for each item
          .map((item) => item.quantity * findProduct(item.productId).price)
          // then add them up
          .reduce((value, element) => value + element);
}
