import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

// TODO: Try this later
// mixin UserListener {
//   late String uid;

//   init(AuthService authService, void Function(String uid) onUidUpdated) {
//     authService.authStateChanges().listen((uid) {
//       this.uid = uid!;
//       onUidUpdated(this.uid);
//     });
//   }
// }

class Cart extends StateNotifier<List<Item>> {
  Cart({required this.authService, required this.dataStore})
      : uid = authService.uid!,
        super([]) {
    init();
  }
  final AuthService authService;
  final DataStore dataStore;

  // Make it late non-nullable as it will always be non-nullable once the app starts
  // (users are signed in as guest immediately)
  String uid;

  void init() {
    authService.authStateChanges().listen((uid) {
      this.uid = uid!;
      state = dataStore.items(this.uid);
    });
  }

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
  //final authStateChanges = ref.watch(authStateChangesProvider);
  // Maybe the cart itself should listen to changes in uid, and adjust accordingly!!!
  // https://github.com/rrousselGit/river_pod/issues/705
  final authService = ref.watch(authServiceProvider);
  return Cart(authService: authService, dataStore: dataStore);
});
