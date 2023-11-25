import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/data_store/data_store.dart';

class AdminOrdersService {
  AdminOrdersService({required this.dataStore});
  final DataStore dataStore;

  // All write methods
  Future<void> updateOrderStatus(Order order) =>
      dataStore.updateOrderStatus(order);
}

final adminOrdersServiceProvider = Provider<AdminOrdersService>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  return AdminOrdersService(dataStore: dataStore);
});

// all read methods as StreamProviders
final allOrdersByDateProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  return dataStore.allOrders();
});
