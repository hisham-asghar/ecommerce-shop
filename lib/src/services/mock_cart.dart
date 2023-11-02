import 'package:my_shop_ecommerce_flutter/src/models/item.dart';

/// Helper class used by MockDataStore
class MockCart {
  MockCart(this.items);
  List<Item> items;

  void addItem(Item item) {
    final itemIndex = items.indexOf(item);
    // if item already exists, update quantity
    if (itemIndex >= 0) {
      final list = List<Item>.from(items);
      list[itemIndex] = Item(
          productId: item.productId,
          quantity: item.quantity + items[itemIndex].quantity);
      items = list;
      // else insert as new item
    } else {
      final list = List<Item>.from(items);
      list.add(item);
      items = list;
    }
  }

  void removeItem(Item item) {
    final list = List<Item>.from(items);
    list.remove(item);
    items = list;
  }

  bool updateItemIfExists(Item item) {
    final productIds = items.map((item) => item.productId).toList();
    final itemIndex = productIds.indexOf(item.productId);
    if (itemIndex >= 0) {
      final list = List<Item>.from(items);
      list[itemIndex] = item;
      items = list;
      return true;
    } else {
      return false;
    }
  }

  void removeAll() {
    items = [];
  }
}
