import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_sync_service.dart';

class AuthService {
  AuthService({required this.authRepository, required this.cartSyncService});
  final AuthRepository authRepository;
  final CartSyncService cartSyncService;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await authRepository.signInWithEmailAndPassword(email, password);
      await cartSyncService.moveItemsToRemote(authRepository.currentUser!.uid);
    } catch (e) {
      // TODO: map errors
      rethrow;
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await authRepository.createUserWithEmailAndPassword(email, password);
      await cartSyncService.moveItemsToRemote(authRepository.currentUser!.uid);
    } catch (e) {
      // TODO: map errors
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await authRepository.sendPasswordResetEmail(email);
    } catch (e) {
      // TODO: map errors
      rethrow;
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final cartSyncService = ref.watch(cartSyncServiceProvider);
  return AuthService(authRepository: authRepository, cartSyncService: cartSyncService);
});
