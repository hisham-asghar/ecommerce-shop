import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address_repository.dart';

class AddressService {
  AddressService(
      {required this.authRepository, required this.addressRepository});
  final AuthRepository authRepository;
  final AddressRepository addressRepository;

  // Future<Address?> getAddress() {
  //   final user = authService.currentUser;
  //   if (user != null) {
  //     return addressRepository.getAddress(user.uid);
  //   } else {
  //     throw AssertionError('uid == null');
  //   }
  // }

  Future<void> submitAddress(Address address) async {
    final user = authRepository.currentUser;
    if (user != null) {
      await addressRepository.submitAddress(user.uid, address);
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

final addressFutureProvider = FutureProvider.autoDispose<Address?>((ref) {
  final addressRepository = ref.watch(addressRepositoryProvider);
  final authService = ref.watch(authRepositoryProvider);
  final user = authService.currentUser;
  if (user != null) {
    return addressRepository.getAddress(user.uid);
  } else {
    throw AssertionError('uid == null');
  }
});

final addressProvider = StreamProvider.autoDispose<Address?>((ref) {
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.asData?.value;
  if (user != null) {
    final addressRepository = ref.watch(addressRepositoryProvider);
    return addressRepository.address(user.uid);
  } else {
    return Stream.fromIterable([null]);
  }
});
