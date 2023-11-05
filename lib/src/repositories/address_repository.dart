import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class AddressRepository {
  AddressRepository({required this.authService, required this.dataStore});
  final AuthService authService;
  final DataStore dataStore;

  // Future<Address?> getAddress() {
  //   final user = authService.currentUser;
  //   if (user != null) {
  //     return dataStore.getAddress(user.uid);
  //   } else {
  //     throw AssertionError('uid == null');
  //   }
  // }

  Future<void> submitAddress(Address address) async {
    final user = authService.currentUser;
    if (user != null) {
      await dataStore.submitAddress(user.uid, address);
    } else {
      throw AssertionError('uid == null');
    }
  }
}

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  final authService = ref.watch(authServiceProvider);
  return AddressRepository(authService: authService, dataStore: dataStore);
});

final addressFutureProvider = FutureProvider.autoDispose<Address?>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  final authService = ref.watch(authServiceProvider);
  final user = authService.currentUser;
  if (user != null) {
    return dataStore.getAddress(user.uid);
  } else {
    throw AssertionError('uid == null');
  }
});

final addressProvider = StreamProvider.autoDispose<Address?>((ref) {
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.maybeWhen(data: (user) => user, orElse: () => null);
  if (user != null) {
    final dataStore = ref.watch(dataStoreProvider);
    return dataStore.address(user.uid);
  } else {
    // TODO: Log error
    return const Stream.empty();
  }
});
