import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthService {
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);

  // Temporary getter, will replace with Firebase stull
  bool get isSignedIn;
}

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

final authServiceProvider = Provider<AuthService>((ref) {
  return MockAuthService();
});
