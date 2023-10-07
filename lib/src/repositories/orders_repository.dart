import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

// This is the *user* orders repository
class OrdersRepository {
  OrdersRepository({required this.authService, required this.dataStore})
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

  Map<String, Order> orders() => dataStore.orders(uid);

  List<Order> ordersByDate() => dataStore.ordersByDate(uid);

  Future<void> placeOrder(Order order) => dataStore.placeOrder(uid, order);
}

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  final authService = ref.watch(authServiceProvider);
  return OrdersRepository(authService: authService, dataStore: dataStore);
});
