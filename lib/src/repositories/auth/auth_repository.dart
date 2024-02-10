import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/app_user.dart';

abstract class AuthRepository {
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
  Stream<bool> isAdminUserChanges();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authService = ref.watch(authRepositoryProvider);
  return authService.authStateChanges();
});

final isAdminUserProvider = StreamProvider.autoDispose<bool>((ref) {
  final authService = ref.watch(authRepositoryProvider);
  return authService.isAdminUserChanges();
});
