import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/services/mock_auth_service.dart';

abstract class AuthService {
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);

  // Temporary getter, will replace with Firebase stull
  bool get isSignedIn;
}

final authServiceProvider = Provider<AuthService>((ref) {
  return MockAuthService();
});
