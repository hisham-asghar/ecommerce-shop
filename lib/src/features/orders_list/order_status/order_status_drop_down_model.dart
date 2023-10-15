import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/admin_orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class OrderStatusDropDownModel extends StateNotifier<WidgetBasicState> {
  OrderStatusDropDownModel(
      {required this.adminOrdersRepository, required this.order})
      : super(const WidgetBasicState.notLoading());
  final AdminOrdersRepository adminOrdersRepository;

  final Order order;

  Future<void> updateOrderStatus(OrderStatus status) async {
    try {
      state = const WidgetBasicState.loading();
      await adminOrdersRepository.updateOrderStatus(order, status);
    } finally {
      state = const WidgetBasicState.notLoading();
    }
  }
}

final orderStatusDropDownModelProvider = StateNotifierProvider.family<
    OrderStatusDropDownModel, WidgetBasicState, Order>((ref, order) {
  final adminOrdersRepository = ref.watch(adminOrdersRepositoryProvider);
  return OrderStatusDropDownModel(
      adminOrdersRepository: adminOrdersRepository, order: order);
});
