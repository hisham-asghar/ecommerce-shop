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
    final user = authService.currentUser;
    if (user != null) {
      await dataStore.placeOrder(user.uid, order);
    } else {
      // TODO: Log error
      throw AssertionError('uid == null');
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
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.maybeWhen(data: (user) => user, orElse: () => null);
  if (user != null) {
    final dataStore = ref.watch(dataStoreProvider);
    return dataStore.ordersByDate(user.uid);
  } else {
    // TODO: Log error
    return const Stream.empty();
  }
});
