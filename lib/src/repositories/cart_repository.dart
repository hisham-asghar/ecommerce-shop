import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class CartRepository {
  CartRepository({required this.authService, required this.dataStore});
  final AuthService authService;
  final DataStore dataStore;

  // TODO: Make these methods more DRY
  List<Item> getItemsList() {
    final uid = authService.uid;
    if (uid != null) {
      return dataStore.getItemsList(uid);
    } else {
      throw AssertionError('uid == null');
    }
  }

  Future<void> addItem(Item item) {
    final uid = authService.uid;
    if (uid != null) {
      return dataStore.addItem(uid, item);
    } else {
      throw AssertionError('uid == null');
    }
  }

  Future<void> removeItem(Item item) {
    final uid = authService.uid;
    if (uid != null) {
      return dataStore.removeItem(uid, item);
    } else {
      throw AssertionError('uid == null');
    }
  }

  Future<bool> updateItemIfExists(Item item) {
    final uid = authService.uid;
    if (uid != null) {
      return dataStore.updateItemIfExists(uid, item);
    } else {
      throw AssertionError('uid == null');
    }
  }

  Future<void> removeAllItems() {
    final uid = authService.uid;
    if (uid != null) {
      return dataStore.removeAllItems(uid);
    } else {
      throw AssertionError('uid == null');
    }
  }
}

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  final authService = ref.watch(authServiceProvider);
  return CartRepository(authService: authService, dataStore: dataStore);
});

final cartItemsListProvider = StreamProvider.autoDispose<List<Item>>((ref) {
  final uidValue = ref.watch(authStateChangesProvider);
  final uid = uidValue.maybeWhen(data: (uid) => uid, orElse: () => null);
  if (uid != null) {
    final dataStore = ref.watch(dataStoreProvider);
    return dataStore.itemsList(uid);
  } else {
    // TODO: Log error
    return const Stream.empty();
  }
});
