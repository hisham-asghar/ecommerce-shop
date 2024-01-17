import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';

abstract class OrdersRepository {
  Stream<List<Order>> watchUserOrders(String uid);

  Future<void> updateOrderStatus(Order order);

  Stream<List<Order>> watchAllOrders();
}

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
