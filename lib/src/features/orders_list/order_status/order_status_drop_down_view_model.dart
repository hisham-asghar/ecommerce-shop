import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/admin_orders_repository.dart';

// TODO: Define State class with
// - loading
// - data(OrderStatus)

class OrderStatusDropDownViewModel extends StateNotifier<bool> {
  OrderStatusDropDownViewModel(
      {required this.adminOrdersRepository, required this.order})
      : super(false);
  final AdminOrdersRepository adminOrdersRepository;

  final Order order;

  Future<void> updateOrderStatus(OrderStatus status) async {
    try {
      state = true;
      await adminOrdersRepository.updateOrderStatus(order, status);
    } finally {
      state = false;
    }
  }
}

final orderStatusDropDownViewModelProvider =
    StateNotifierProvider.family<OrderStatusDropDownViewModel, bool, Order>(
        (ref, order) {
  final adminOrdersRepository = ref.watch(adminOrdersRepositoryProvider);
  return OrderStatusDropDownViewModel(
      adminOrdersRepository: adminOrdersRepository, order: order);
});
