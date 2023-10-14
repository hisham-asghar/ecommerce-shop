import 'package:flutter/foundation.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/admin_orders_repository.dart';

class OrderStatusDropDownViewModel {
  OrderStatusDropDownViewModel(
      {required this.adminOrdersRepository, required this.order});
  final AdminOrdersRepository adminOrdersRepository;

  final Order order;
  var isLoading = ValueNotifier<bool>(false);

  Future<void> updateOrderStatus(OrderStatus status) async {
    try {
      isLoading.value = true;
      await adminOrdersRepository.updateOrderStatus(order, status);
    } finally {
      isLoading.value = false;
    }
  }
}
