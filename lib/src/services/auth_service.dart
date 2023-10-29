import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AppUser {
  String get uid;
  bool get isSignedIn;
  bool get isAdmin;
}

abstract class AuthService {
  Future<void> signInAnonymously();
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
}

final authServiceProvider = Provider<AuthService>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
});
