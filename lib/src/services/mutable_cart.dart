import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';

/// Helper class used to mutate the items in the shopping cart.
class MutableCart {
  MutableCart(this.items);
  Map<String, int> items;

  /// Helper constructor to initialize from a [Cart] object.
  MutableCart.from(Cart cart) : items = cart.items;

  /// Helper method to return an immutable [Cart] object.
  Cart toCart() => Cart(items);

  void addItem(Item item) {
    if (items.containsKey(item.productId)) {
      items[item.productId] = item.quantity + items[item.productId]!;
    } else {
      items[item.productId] = item.quantity;
    }
  }

  void removeItem(Item item) {
    items.remove(item.productId);
  }

  bool updateItemIfExists(Item item) {
    if (items.containsKey(item.productId)) {
      items[item.productId] = item.quantity;
      return true;
    } else {
      return false;
    }
  }

  void removeAll() {
    items = {};
  }
}
