import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/orders_repository.dart';

// all read methods as StreamProviders
final allOrdersByDateProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final ordersRepository = ref.watch(ordersRepositoryProvider);
  return ordersRepository.watchAllOrders();
});
