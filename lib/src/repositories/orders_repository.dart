import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class OrdersRepository {
  OrdersRepository({required this.dataStore});
  final DataStore dataStore;

  Map<String, Order> get orders => dataStore.orders;

  Future<void> placeOrder(Order order) => dataStore.placeOrder(order);

  List<Order> get ordersByDate => dataStore.ordersByDate;
}

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  return OrdersRepository(dataStore: dataStore);
});
