import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/orders_repository.dart';

class AdminOrdersService {
  AdminOrdersService({required this.ordersRepository});
  final OrdersRepository ordersRepository;

  // All write methods
  Future<void> updateOrderStatus(Order order) =>
      ordersRepository.updateOrderStatus(order);
}

final adminOrdersServiceProvider = Provider<AdminOrdersService>((ref) {
  final ordersRepository = ref.watch(ordersRepositoryProvider);
  return AdminOrdersService(ordersRepository: ordersRepository);
});

// all read methods as StreamProviders
final allOrdersByDateProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final ordersRepository = ref.watch(ordersRepositoryProvider);
  return ordersRepository.allOrders();
});
