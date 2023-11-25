import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/delay.dart';

class MockAddressRepository implements AddressRepository {
  final Map<String, Address> _addressData = {};
  final _addressDataSubject = BehaviorSubject<Map<String, Address>>.seeded({});
  Stream<Map<String, Address>> get _addressDataStream =>
      _addressDataSubject.stream;

  @override
  Future<Address?> getAddress(String uid) {
    return Future.value(_addressData[uid]);
  }

  @override
  Stream<Address?> address(String uid) {
    return _addressDataStream.map((addressData) => addressData[uid]);
  }

  @override
  Future<void> submitAddress(String uid, Address address) async {
    await delay();
    _addressData[uid] = address;
    _addressDataSubject.add(_addressData);
  }
}
