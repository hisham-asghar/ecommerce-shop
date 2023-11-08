import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart_total.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cloud_functions/cloud_functions.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store/data_store.dart';

class CartRepository {
  CartRepository(
      {required this.authService,
      required this.dataStore,
      required this.cloudFunctions});
  final AuthService authService;
  final DataStore dataStore;
  final CloudFunctions cloudFunctions;

  // TODO: Make these methods more DRY
  Future<List<Item>> getItemsList() {
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
      // TODO: This will replace the item quantity if it already exists
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

  Future<void> updateItemIfExists(Item item) {
    // Is there a way to cache this so updates are faster?
    final user = authService.currentUser;
    if (user != null) {
      return dataStore.updateItemIfExists(user.uid, item);
    } else {
      throw AssertionError('uid == null');
    }
  }

  Future<Order> placeOrder() async {
    final user = authService.currentUser;
    if (user != null) {
      return await cloudFunctions.placeOrder(user.uid);
    } else {
      throw AssertionError('uid == null');
    }
  }
}

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  final authService = ref.watch(authServiceProvider);
  final cloudFunctions = ref.watch(cloudFunctionsProvider);
  return CartRepository(
    authService: authService,
    dataStore: dataStore,
    cloudFunctions: cloudFunctions,
  );
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

final cartTotalProvider = StreamProvider<CartTotal>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  final authService = ref.watch(authServiceProvider);
  final user = authService.currentUser!;
  return dataStore.cartTotal(user.uid);
});
