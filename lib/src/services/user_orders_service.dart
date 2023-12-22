import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/orders_repository.dart';

// All read operations go here
final ordersByDateProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.asData?.value;
  if (user != null) {
    final ordersRepository = ref.watch(ordersRepositoryProvider);
    return ordersRepository.userOrders(user.uid);
  } else {
    // TODO: Log error
    return const Stream.empty();
  }
});

// final userOrderProvider =
//     StreamProvider.autoDispose.family<Order, String>((ref, orderId) {
//   final userValue = ref.watch(authStateChangesProvider);
//   final user = userValue.asData?.value;
//   if (user != null) {
//     final ordersRepository = ref.watch(ordersRepositoryProvider);
//     return ordersRepository.userOrder(user.uid, orderId);
//   } else {
//     // TODO: Log error
//     return const Stream.empty();
//   }
// });
