import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

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

class MockAuthService implements AuthService {
  @override
  User? currentUser;

  // Problem: this won't replay the previous value when a new listener is registered
  // Use ValueNotifier instead?
  final _authStateChangesController = BehaviorSubject<User?>.seeded(null);

  @override
  Stream<User?> authStateChanges() => _authStateChangesController.stream;

  @override
  Future<void> signInAnonymously() async {
    await Future.delayed(const Duration(seconds: 2));
    if (currentUser != null) {
      throw UnsupportedError(
          'User is already signed in and can\'t sign in as anonymously');
    }
    _createNewUser(isSignedIn: false, isAdmin: false);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (currentUser == null) {
      _createNewUser(isSignedIn: true, isAdmin: true);
    } else {
      _updateUser(isSignedIn: true, isAdmin: true);
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (currentUser == null) {
      _createNewUser(isSignedIn: true, isAdmin: true);
    } else {
      _updateUser(isSignedIn: true, isAdmin: true);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 2));
    // here we just pretend to sign out. All we do is to create a new guest user with a different UID
    _createNewUser(isSignedIn: false, isAdmin: false);
  }

  void _createNewUser({required bool isSignedIn, required bool isAdmin}) {
    currentUser = User(
      uid: const Uuid().v1(),
      isSignedIn: isSignedIn,
      isAdmin: isAdmin,
    );
    _authStateChangesController.add(currentUser);
    print('New uid: ${currentUser!.uid}');
  }

  void _updateUser({required bool isSignedIn, required bool isAdmin}) {
    currentUser = currentUser!.copyWith(
      isSignedIn: isSignedIn,
      isAdmin: isAdmin,
    );
    _authStateChangesController.add(currentUser);
    print('New uid: ${currentUser!.uid}');
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return MockAuthService();
});

final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
});
