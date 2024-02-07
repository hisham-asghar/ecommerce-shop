import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address_repository.dart';

class AddressService {
  AddressService(
      {required this.authRepository, required this.addressRepository});
  final AuthRepository authRepository;
  final AddressRepository addressRepository;

  Future<void> setUserAddress(Address address) async {
    final user = authRepository.currentUser;
    if (user != null) {
      await addressRepository.setAddress(user.uid, address);
    } else {
      throw AssertionError('uid == null');
    }
  }
}

final addressServiceProvider = Provider<AddressService>((ref) {
  final addressRepository = ref.watch(addressRepositoryProvider);
  final authService = ref.watch(authRepositoryProvider);
  return AddressService(
    authRepository: authService,
    addressRepository: addressRepository,
  );
});
