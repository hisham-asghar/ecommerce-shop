import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

// TODO: Use this
class AddressRepository {
  AddressRepository({required this.dataStore});
  final DataStore dataStore;

  bool get isAddressSet => dataStore.isAddressSet;

  Future<void> submitAddress(Address address) =>
      dataStore.submitAddress(address);
}
