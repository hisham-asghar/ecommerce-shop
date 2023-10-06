import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

abstract class AuthService {
  Future<void> signInAnonymously();
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);

  // Temporary getter, will replace with Firebase stull
  // if true, user is authenticated
  // if false, user is guest (anonymous)
  bool get isSignedIn;

  /// ID of the signed in user. This is null when the user is signed out
  String? get uid;
}

class MockAuthService implements AuthService {
  @override
  bool isSignedIn = false;

  @override
  String? uid;

  @override
  Future<void> signInAnonymously() async {
    await Future.delayed(const Duration(seconds: 2));
    isSignedIn = false;
    uid = const Uuid().v1();
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    isSignedIn = true;
    uid = const Uuid().v1();
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    isSignedIn = true;
    uid = const Uuid().v1();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return Future.delayed(const Duration(seconds: 2));
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return MockAuthService();
});
