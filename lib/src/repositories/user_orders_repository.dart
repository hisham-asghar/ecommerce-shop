import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

// All read operations go here
final ordersByDateProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.maybeWhen(data: (user) => user, orElse: () => null);
  if (user != null) {
    final dataStore = ref.watch(dataStoreProvider);
    return dataStore.orders(user.uid);
  } else {
    // TODO: Log error
    return const Stream.empty();
  }
});
