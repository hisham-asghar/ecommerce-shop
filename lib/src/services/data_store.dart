import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';

abstract class DataStore {
  // TODO: This should depend on the authenticated user
  Future<void> submitAddress(Address address);

  bool get isAddressSet;
}

class MockDataStore implements DataStore {
  @override
  Future<void> submitAddress(Address address) async {
    await Future.delayed(const Duration(seconds: 2));
    isAddressSet = true;
  }

  @override
  var isAddressSet = false;
}

final dataStoreProvider = Provider<DataStore>((ref) {
  return MockDataStore();
});
