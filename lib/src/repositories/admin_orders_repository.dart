import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class AdminOrdersRepository {
  AdminOrdersRepository({required this.dataStore});
  final DataStore dataStore;

  List<Order> allOrdersByDate() => dataStore.allOrdersByDate();
}

final adminOrdersRepositoryProvider = Provider<AdminOrdersRepository>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  return AdminOrdersRepository(dataStore: dataStore);
});
