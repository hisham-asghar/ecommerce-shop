import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

abstract class AuthService {
  Future<void> signInAnonymously();
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Stream<String?> authStateChanges();

  // Temporary getter, will replace with Firebase stull
  // if true, user is authenticated
  // if false, user is guest (anonymous)
  bool get isSignedIn;

  // True if user is an admin
  bool get isAdmin;

  /// ID of the signed in user. This is null when the user is signed out
  String? get uid;
}

class MockAuthService implements AuthService {
  @override
  bool isSignedIn = false;

  @override
  bool isAdmin = false;

  @override
  String? uid;

  // Problem: this won't replay the previous value when a new listener is registered
  // Use ValueNotifier instead?
  final _authStateChangesController = StreamController<String?>.broadcast();

  @override
  Stream<String?> authStateChanges() => _authStateChangesController.stream;

  @override
  Future<void> signInAnonymously() async {
    await Future.delayed(const Duration(seconds: 2));
    if (uid != null) {
      throw UnsupportedError(
          'User is already signed in and can\'t sign in as anonymously');
    }
    isSignedIn = false;
    // assign new uid
    _createNewUid();
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    isSignedIn = true;
    // always enable admin for authenticated users
    isAdmin = true;
    // keep current uid if one already exists
    if (uid == null) {
      _createNewUid();
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    isSignedIn = true;
    // always enable admin for authenticated users
    isAdmin = true;
    // keep current uid if one already exists
    if (uid == null) {
      _createNewUid();
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
    isSignedIn = false;
    isAdmin = false;
    // assign new uid
    _createNewUid();
  }

  void _createNewUid() {
    uid = const Uuid().v1();
    _authStateChangesController.add(uid);
    print('New uid: $uid');
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return MockAuthService();
});

final authStateChangesProvider = StreamProvider.autoDispose<String?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
});
