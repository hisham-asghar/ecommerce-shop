import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/domain/address.dart';

abstract class AddressRepository {
  Future<Address?> fetchAddress(String uid);

  Stream<Address?> watchAddress(String uid);

  Future<void> setAddress(String uid, Address address);
}

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
