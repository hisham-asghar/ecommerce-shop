import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';

abstract class OrdersManager {
  // All orders ever created by current user
  Map<String, Order> get orders;

  Future<void> placeOrder(Order order);
}

class MockOrdersManager implements OrdersManager {
  @override
  Map<String, Order> orders = {};

  @override
  Future<void> placeOrder(Order order) async {
    await Future.delayed(const Duration(seconds: 2));
    orders[order.id] = order;
  }
}

final ordersProvider = Provider<OrdersManager>((ref) {
  return MockOrdersManager();
});
