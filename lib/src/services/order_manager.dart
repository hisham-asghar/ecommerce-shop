// TODO: Should this be a StateNotifier?
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';

abstract class OrdersManager {
  // All orders ever created by current user
  Map<String, Order> get orders;
}

class MockOrdersManager implements OrdersManager {
  @override
  Map<String, Order> orders = {};

  void placeOrder(Order order) {
    orders[order.id] = order;
  }
}

final ordersProvider = Provider<OrdersManager>((ref) {
  return MockOrdersManager();
});
