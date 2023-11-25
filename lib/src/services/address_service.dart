import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/address.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/data_store/data_store.dart';

class AddressService {
  AddressService({required this.authService, required this.dataStore});
  final AuthRepository authService;
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

final addressServiceProvider = Provider<AddressService>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  final authService = ref.watch(authRepositoryProvider);
  return AddressService(authService: authService, dataStore: dataStore);
});

final addressFutureProvider = FutureProvider.autoDispose<Address?>((ref) {
  final dataStore = ref.watch(dataStoreProvider);
  final authService = ref.watch(authRepositoryProvider);
  final user = authService.currentUser;
  if (user != null) {
    return dataStore.getAddress(user.uid);
  } else {
    throw AssertionError('uid == null');
  }
});

final addressProvider = StreamProvider.autoDispose<Address?>((ref) {
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.asData?.value;
  if (user != null) {
    final dataStore = ref.watch(dataStoreProvider);
    return dataStore.address(user.uid);
  } else {
    return Stream.fromIterable([null]);
  }
});
