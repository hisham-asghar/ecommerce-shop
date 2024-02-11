import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/exceptions/app_exception.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/exceptions/run_catching_exceptions.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_sync_service.dart';

class AuthService {
  AuthService({required this.authRepository, required this.cartSyncService});
  final AuthRepository authRepository;
  final CartSyncService cartSyncService;

  Future<Result<AppException, void>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final result = await runCatchingExceptions(() {
      return authRepository.signInWithEmailAndPassword(email, password);
    });
    return result.when(
      (error) => Future.value(Error(error)),
      (success) {
        final user = authRepository.currentUser;
        if (user != null) {
          // * Note: Since cartSyncService.moveItemsToRemote does not throw,
          // * we have to unwrap the result (and return a Future).
          return cartSyncService.moveItemsToRemote(user.uid);
        } else {
          // * will be returned as-is by [runCatchingExceptions]
          return Future.value(const Error(AppException.userNotSignedIn()));
        }
      },
    );
  }

  Future<Result<AppException, void>> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final result = await runCatchingExceptions(() {
      return authRepository.createUserWithEmailAndPassword(email, password);
    });
    return result.when(
      (error) => Future.value(Error(error)),
      (success) {
        final user = authRepository.currentUser;
        if (user != null) {
          // * Note: Since cartSyncService.moveItemsToRemote does not throw,
          // * we have to unwrap the result (and return a Future).
          return cartSyncService.moveItemsToRemote(user.uid);
        } else {
          // * will be returned as-is by [runCatchingExceptions]
          return Future.value(const Error(AppException.userNotSignedIn()));
        }
      },
    );
  }

  Future<Result<AppException, void>> sendPasswordResetEmail(String email) =>
      runCatchingExceptions(() {
        return authRepository.sendPasswordResetEmail(email);
      });
}

final authServiceProvider = Provider<AuthService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final cartSyncService = ref.watch(cartSyncServiceProvider);
  return AuthService(
    authRepository: authRepository,
    cartSyncService: cartSyncService,
  );
});
