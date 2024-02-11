import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/exceptions/app_exception.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/exceptions/run_catching_exceptions.dart';

class AddressService {
  AddressService(
      {required this.authRepository, required this.addressRepository});
  final AuthRepository authRepository;
  final AddressRepository addressRepository;

  Future<Result<AppException, void>> setUserAddress(Address address) =>
      runCatchingExceptions(() async {
        final user = authRepository.currentUser;
        if (user != null) {
          await addressRepository.setAddress(user.uid, address);
        } else {
          // * will be returned as-is by [runCatchingExceptions]
          throw const AppException.userNotSignedIn();
        }
      });
}

final addressServiceProvider = Provider<AddressService>((ref) {
  final addressRepository = ref.watch(addressRepositoryProvider);
  final authService = ref.watch(authRepositoryProvider);
  return AddressService(
    authRepository: authService,
    addressRepository: addressRepository,
  );
});
