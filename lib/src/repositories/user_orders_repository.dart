import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class UserOrdersRepository {
  UserOrdersRepository({required this.authService, required this.dataStore});
  final AuthService authService;
  final DataStore dataStore;

  // All write operations go here
  Future<void> placeOrder(Order order) async {
    final uid = authService.uid;
    if (uid != null) {
      await dataStore.placeOrder(uid, order);
    } else {
      // TODO: Log error
      throw AssertionError('Can\'t place order as uid == null');
    }
  }
}

final userOrdersRepositoryProvider = Provider<UserOrdersRepository>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  final authService = ref.watch(authServiceProvider);
  return UserOrdersRepository(authService: authService, dataStore: dataStore);
});

// All read operations go here
final ordersByDateProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final uidValue = ref.watch(authStateChangesProvider);
  final uid = uidValue.maybeWhen(data: (uid) => uid, orElse: () => null);
  if (uid != null) {
    final dataStore = ref.watch(dataStoreProvider);
    return dataStore.ordersByDate(uid);
  } else {
    // TODO: Log error
    return const Stream.empty();
  }
});
