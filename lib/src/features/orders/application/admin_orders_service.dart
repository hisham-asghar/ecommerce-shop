import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/data/orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/domain/order.dart';

// all read methods as StreamProviders
final allOrdersByDateProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final ordersRepository = ref.watch(ordersRepositoryProvider);
  return ordersRepository.watchAllOrders();
});
