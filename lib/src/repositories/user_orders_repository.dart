import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

// This is the *user* orders repository
class UserOrdersRepository {
  UserOrdersRepository({required this.authService, required this.dataStore})
      : uid = authService.uid! {
    init();
  }
  final AuthService authService;
  final DataStore dataStore;

  // TODO: Don't copy paste this logic
  // Make it late non-nullable as it will always be non-nullable once the app starts
  // (users are signed in as guest immediately)
  String uid;
  void init() {
    authService.authStateChanges().listen((uid) {
      this.uid = uid!;
    });
  }

  //Stream<Map<String, Order>> orders() => dataStore.orders(uid);

  Stream<List<Order>> ordersByDate() => dataStore.ordersByDate(uid);

  Future<void> placeOrder(Order order) => dataStore.placeOrder(uid, order);
}

final userOrdersRepositoryProvider = Provider<UserOrdersRepository>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  final authService = ref.watch(authServiceProvider);
  return UserOrdersRepository(authService: authService, dataStore: dataStore);
});

final ordersByDateProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final userOrdersRepository = ref.watch(userOrdersRepositoryProvider);
  return userOrdersRepository.ordersByDate();
});


// final ordersByDateProvider =
//     StreamProvider.autoDispose.family<List<Order>, String>((ref, uid) {
//   final dataStore = ref.watch(dataStoreProvider);
//   return dataStore.ordersByDate(uid);
// });
