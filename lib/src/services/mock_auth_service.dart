import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';

class MockAuthService implements AuthService {
  @override
  var isSignedIn = false;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    isSignedIn = true;
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    isSignedIn = true;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return Future.delayed(const Duration(seconds: 2));
  }
}
