import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';

/// Helper class used to mutate the items in the shopping cart.
extension MutableCart on Cart {
  Cart addItem(Item item) {
    final copy = Map<String, int>.from(items);
    if (copy.containsKey(item.productId)) {
      copy[item.productId] = item.quantity + copy[item.productId]!;
    } else {
      copy[item.productId] = item.quantity;
    }
    return Cart(copy);
  }

  Cart addItems(List<Item> itemsToAdd) {
    final copy = Map<String, int>.from(items);
    for (var item in itemsToAdd) {
      if (copy.containsKey(item.productId)) {
        copy[item.productId] = item.quantity + copy[item.productId]!;
      } else {
        copy[item.productId] = item.quantity;
      }
    }
    return Cart(copy);
  }

  Cart removeItem(Item item) {
    final copy = Map<String, int>.from(items);
    copy.remove(item.productId);
    return Cart(copy);
  }

  Cart updateItemIfExists(Item item) {
    if (items.containsKey(item.productId)) {
      final copy = Map<String, int>.from(items);
      copy[item.productId] = item.quantity;
      return Cart(copy);
    } else {
      return this;
    }
  }

  Cart clear() {
    return const Cart();
  }
}
