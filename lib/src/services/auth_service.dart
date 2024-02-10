import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_exception.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_sync_service.dart';

class AuthService {
  AuthService({required this.authRepository, required this.cartSyncService});
  final AuthRepository authRepository;
  final CartSyncService cartSyncService;

  Future<Result<AuthException, void>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await authRepository.signInWithEmailAndPassword(email, password);
      await cartSyncService.moveItemsToRemote(authRepository.currentUser!.uid);
      return const Success(null);
    } on AuthException catch (e) {
      // TODO: Error reporting
      return Error(e);
    }
  }

  Future<Result<AuthException, void>> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await authRepository.createUserWithEmailAndPassword(email, password);
      await cartSyncService.moveItemsToRemote(authRepository.currentUser!.uid);
      return const Success(null);
    } on AuthException catch (e) {
      // TODO: Error reporting
      return Error(e);
    }
  }

  Future<Result<AuthException, void>> sendPasswordResetEmail(
      String email) async {
    try {
      await authRepository.sendPasswordResetEmail(email);
      return const Success(null);
    } on AuthException {
      // TODO: Error reporting
      return const Error(AuthException.unknown());
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final cartSyncService = ref.watch(cartSyncServiceProvider);
  return AuthService(
      authRepository: authRepository, cartSyncService: cartSyncService);
});
