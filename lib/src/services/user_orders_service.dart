import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/data_store/data_store.dart';

// All read operations go here
final ordersByDateProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.asData?.value;
  if (user != null) {
    final dataStore = ref.watch(dataStoreProvider);
    return dataStore.userOrders(user.uid);
  } else {
    // TODO: Log error
    return const Stream.empty();
  }
});
