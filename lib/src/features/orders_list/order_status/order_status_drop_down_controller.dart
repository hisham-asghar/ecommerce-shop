import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/admin_orders_service.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class OrderStatusDropDownController extends StateNotifier<WidgetBasicState> {
  OrderStatusDropDownController(
      {required this.adminOrdersService, required this.order})
      : super(const WidgetBasicState.notLoading());
  final AdminOrdersService adminOrdersService;

  final Order order;

  Future<void> updateOrderStatus(OrderStatus status) async {
    try {
      state = const WidgetBasicState.loading();
      final updatedOrder = order.copyWith(orderStatus: status);
      await adminOrdersService.updateOrderStatus(updatedOrder);
    } catch (e) {
      state = const WidgetBasicState.error('Could not update order status');
    } finally {
      state = const WidgetBasicState.notLoading();
    }
  }
}

final orderStatusDropDownControllerProvider = StateNotifierProvider.family<
    OrderStatusDropDownController, WidgetBasicState, Order>((ref, order) {
  final adminOrdersRepository = ref.watch(adminOrdersServiceProvider);
  return OrderStatusDropDownController(
      adminOrdersService: adminOrdersRepository, order: order);
});
