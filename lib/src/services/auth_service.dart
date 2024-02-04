import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';

class AuthService {
  AuthService({required this.authRepository, required this.cartService});
  final AuthRepository authRepository;
  final CartService cartService;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await authRepository.signInWithEmailAndPassword(email, password);
      await cartService.copyItemsToRemote();
    } catch (e) {
      // TODO: map errors
      rethrow;
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await authRepository.createUserWithEmailAndPassword(email, password);
      await cartService.copyItemsToRemote();
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
  final cartService = ref.watch(cartServiceProvider);
  return AuthService(authRepository: authRepository, cartService: cartService);
});
