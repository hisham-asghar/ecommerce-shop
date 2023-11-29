import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';

abstract class OrdersRepository {
  Stream<Order> userOrder(String uid, String orderId);

  Stream<List<Order>> userOrders(String uid);

  Future<void> updateOrderStatus(Order order);

  Stream<List<Order>> allOrders();
}

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
