import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';

// TODO: Should this be OrdersRepository?
abstract class OrdersManager {
  // All orders ever created by current user
  Map<String, Order> get orders;

  // TODO: move this to a view model
  List<Order> get ordersByDate;

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

  @override
  List<Order> get ordersByDate {
    final ordersList = orders.values.toList();
    ordersList.sort(
      (lhs, rhs) => rhs.orderDate.compareTo(lhs.orderDate),
    );
    return ordersList;
  }
}

final ordersProvider = Provider<OrdersManager>((ref) {
  return MockOrdersManager();
});
