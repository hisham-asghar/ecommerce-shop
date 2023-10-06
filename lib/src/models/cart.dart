import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class Cart extends StateNotifier<List<Item>> {
  Cart({required this.uid, required this.dataStore})
      : super(dataStore.items(uid));
  final String uid;
  final DataStore dataStore;

  void addItem(Item item) {
    dataStore.addItem(uid, item);
    state = dataStore.items(uid);
  }

  void removeItem(Item item) {
    dataStore.removeItem(uid, item);
    state = dataStore.items(uid);
  }

  bool updateItemIfExists(Item item) {
    final result = dataStore.updateItemIfExists(uid, item);
    if (result) {
      state = dataStore.items(uid);
    }
    return result;
  }

  void removeAll() {
    dataStore.removeAllItems(uid);
    state = dataStore.items(uid);
  }
}

final cartProvider = StateNotifierProvider<Cart, List<Item>>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  // TODO: Read this from auth
  const uid = '123';
  return Cart(uid: uid, dataStore: dataStore);
});
