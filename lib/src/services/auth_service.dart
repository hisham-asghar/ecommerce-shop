import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/services/mock_auth_service.dart';

class User {
  User({
    required this.uid,
    required this.isSignedIn,
    required this.isAdmin,
  });
  // True if user is an admin
  final String uid;
  // Temporary getter, will replace with Firebase stull
  // if true, user is authenticated
  // if false, user is guest (anonymous)
  final bool isSignedIn;
  // True if user is an admin
  final bool isAdmin;

  User copyWith({
    String? uid,
    bool? isSignedIn,
    bool? isAdmin,
  }) {
    return User(
      uid: uid ?? this.uid,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  @override
  String toString() =>
      'User(uid: $uid, isSignedIn: $isSignedIn, isAdmin: $isAdmin)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uid == uid &&
        other.isSignedIn == isSignedIn &&
        other.isAdmin == isAdmin;
  }

  @override
  int get hashCode => uid.hashCode ^ isSignedIn.hashCode ^ isAdmin.hashCode;
}

abstract class AuthService {
  Future<void> signInAnonymously();
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Stream<User?> authStateChanges();
  User? get currentUser;
}

final authServiceProvider = Provider<AuthService>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});

final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
});
