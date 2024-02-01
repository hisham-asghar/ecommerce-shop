import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/in_memory_store.dart';
import 'package:rxdart/rxdart.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';

class FakeAddressRepository implements AddressRepository {
  FakeAddressRepository({this.addDelay = true});
  final bool addDelay;

  final _address = InMemoryStore<Map<String, Address>>({});

  @override
  Future<Address?> fetchAddress(String uid) {
    return Future.value(_address.value[uid]);
  }

  @override
  Stream<Address?> watchAddress(String uid) {
    return _address.stream.map((addressData) => addressData[uid]);
  }

  @override
  Future<void> submitAddress(String uid, Address address) async {
    await delay(addDelay);
    final value = _address.value;
    value[uid] = address;
    _address.value = value;
  }
}
