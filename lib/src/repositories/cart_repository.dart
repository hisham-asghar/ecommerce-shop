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
    final user = authService.currentUser;
    if (user != null) {
      return dataStore.getItemsList(user.uid);
    } else {
      throw AssertionError('uid == null');
    }
  }

  Future<void> addItem(Item item) {
    final user = authService.currentUser;
    if (user != null) {
      return dataStore.addItem(user.uid, item);
    } else {
      throw AssertionError('uid == null');
    }
  }

  Future<void> removeItem(Item item) {
    final user = authService.currentUser;
    if (user != null) {
      return dataStore.removeItem(user.uid, item);
    } else {
      throw AssertionError('uid == null');
    }
  }

  Future<bool> updateItemIfExists(Item item) {
    final user = authService.currentUser;
    if (user != null) {
      return dataStore.updateItemIfExists(user.uid, item);
    } else {
      throw AssertionError('uid == null');
    }
  }

  Future<void> removeAllItems() {
    final user = authService.currentUser;
    if (user != null) {
      return dataStore.removeAllItems(user.uid);
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
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.maybeWhen(data: (user) => user, orElse: () => null);
  if (user != null) {
    final dataStore = ref.watch(dataStoreProvider);
    return dataStore.itemsList(user.uid);
  } else {
    // TODO: Log error
    return const Stream.empty();
  }
});
