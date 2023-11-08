import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store/data_store.dart';

class AdminOrdersRepository {
  AdminOrdersRepository({required this.dataStore});
  final DataStore dataStore;

  // All write methods
  Future<void> updateOrderStatus(Order order) =>
      dataStore.updateOrderStatus(order);
}

final adminOrdersRepositoryProvider = Provider<AdminOrdersRepository>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  return AdminOrdersRepository(dataStore: dataStore);
});

// all read methods as StreamProviders
final allOrdersByDateProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  return dataStore.allOrders();
});
