import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class AddressRepository {
  AddressRepository({required this.authService, required this.dataStore});
  final AuthService authService;
  final DataStore dataStore;

  Address? getAddress() {
    final uid = authService.uid;
    if (uid != null) {
      return dataStore.getAddress(uid);
    } else {
      throw AssertionError('uid == null');
    }
  }

  Future<void> submitAddress(Address address) async {
    final uid = authService.uid;
    if (uid != null) {
      await dataStore.submitAddress(uid, address);
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

final addressProvider = StreamProvider.autoDispose<Address?>((ref) {
  final uidValue = ref.watch(authStateChangesProvider);
  final uid = uidValue.maybeWhen(data: (uid) => uid, orElse: () => null);
  if (uid != null) {
    final dataStore = ref.watch(dataStoreProvider);
    return dataStore.address(uid);
  } else {
    // TODO: Log error
    return const Stream.empty();
  }
});
