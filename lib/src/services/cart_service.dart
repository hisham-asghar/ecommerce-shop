import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/cart_total.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/item.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/products_service.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/data_store/data_store.dart';

class CartService {
  CartService(
      {required this.authService,
      required this.remoteDataStore,
      required this.localDataStore,
      required this.cloudFunctions});
  final AuthRepository authService;
  final CartDataStore remoteDataStore;
  final LocalCartDataStore localDataStore;
  final CloudFunctionsRepository cloudFunctions;

  Future<List<Item>> getItemsList() {
    final user = authService.currentUser;
    if (user != null) {
      return remoteDataStore.getItemsList(user.uid);
    } else {
      return localDataStore.getItemsList();
    }
  }

  Future<void> addItem(Item item) {
    final user = authService.currentUser;
    if (user != null) {
      // This will replace the item quantity if it already exists
      return remoteDataStore.addItem(user.uid, item);
    } else {
      return localDataStore.addItem(item);
    }
  }

  Future<void> removeItem(Item item) {
    final user = authService.currentUser;
    if (user != null) {
      return remoteDataStore.removeItem(user.uid, item);
    } else {
      return localDataStore.removeItem(item);
    }
  }

  Future<void> updateItemIfExists(Item item) {
    // Is there a way to cache this so updates are faster?
    final user = authService.currentUser;
    if (user != null) {
      return remoteDataStore.updateItemIfExists(user.uid, item);
    } else {
      return localDataStore.updateItemIfExists(item);
    }
  }

  Future<void> copyItemsToRemote() async {
    final user = authService.currentUser;
    if (user != null) {
      try {
        final items = await localDataStore.getItemsList();
        await remoteDataStore.addAllItems(user.uid, items);
        await localDataStore.clear();
      } catch (e, _) {
        // TODO: Report error
        print(e);
      }
    } else {
      throw AssertionError('user uid == null');
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

final cartServiceProvider = Provider<CartService>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  final localDataStore = ref.watch(localCartDataStoreProvider);
  final authService = ref.watch(authRepositoryProvider);
  final cloudFunctions = ref.watch(cloudFunctionsRepositoryProvider);
  return CartService(
    authService: authService,
    remoteDataStore: dataStore,
    localDataStore: localDataStore,
    cloudFunctions: cloudFunctions,
  );
});

final cartItemsListProvider = StreamProvider.autoDispose<List<Item>>((ref) {
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.asData?.value;
  if (user != null) {
    final dataStore = ref.watch(dataStoreProvider);
    return dataStore.itemsList(user.uid);
  } else {
    final localDataStore = ref.watch(localCartDataStoreProvider);
    return localDataStore.itemsList();
  }
});

final cartTotalProvider = StreamProvider.autoDispose<CartTotal>((ref) {
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.asData?.value;
  if (user != null) {
    final dataStore = ref.watch(dataStoreProvider);
    return dataStore.cartTotal(user.uid);
  } else {
    final productsListValue = ref.watch(productsListProvider);
    final productsList = productsListValue.asData?.value ?? [];
    final localDataStore = ref.watch(localCartDataStoreProvider);
    return localDataStore.cartTotal(productsList);
  }
});
