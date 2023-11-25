import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address.dart';

abstract class AddressRepository {
  Future<Address?> getAddress(String uid);

  Stream<Address?> address(String uid);

  Future<void> submitAddress(String uid, Address address);
}

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
