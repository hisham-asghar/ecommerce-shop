import 'package:my_shop_ecommerce_flutter/src/models/item.dart';

// TODO: This is no longer needed?
class ItemsList {
  ItemsList(this.items);
  final List<Item> items;

  @override
  int get hashCode => items.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is ItemsList) {
      return items == other.items;
    }
    return false;
  }

  @override
  String toString() {
    return 'ItemsList($items)';
  }
}
