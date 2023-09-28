import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/items_list.dart';

class Cart extends StateNotifier<ItemsList> {
  Cart() : super(ItemsList([]));

  void addItem(Item item) {
    final itemIndex = state.items.indexOf(item);
    // if item already exists, update quantity
    if (itemIndex >= 0) {
      final list = List<Item>.from(state.items);
      list[itemIndex] = Item(
          productId: item.productId,
          quantity: item.quantity + state.items[itemIndex].quantity);
      state = ItemsList(list);
      // else insert as new item
    } else {
      final list = List<Item>.from(state.items);
      list.add(item);
      state = ItemsList(list);
    }
  }

  void removeItem(Item item) {
    final list = List<Item>.from(state.items);
    list.remove(item);
    state = ItemsList(list);
  }

  bool updateItemIfExists(Item item) {
    final itemIndex = state.items.indexOf(item);
    if (itemIndex >= 0) {
      final list = List<Item>.from(state.items);
      list[itemIndex] = item;
      state = ItemsList(list);
      return true;
    } else {
      return false;
    }
  }
}

final cartProvider = StateNotifierProvider<Cart, ItemsList>((ref) {
  return Cart();
});
