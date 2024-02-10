import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_shop_ecommerce_flutter/src/models/app_user.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_exception.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseAppUser implements AppUser {
  FirebaseAppUser(this._user);
  final User _user;

  @override
  String get uid => _user.uid;

  @override
  String? get email => _user.email;

  @override
  Future<bool> isAdminUser() async {
    // Note: when a user is first created, there is no claim available until
    // the cloud function returns. This can be fixed with a sign-out / sign-in
    // but it's not ideal.
    // Though it's ok since we can ask admins to do that once.
    // See https://github.com/bizz84/my_shop_ecommerce_flutter/issues/42
    final idTokenResult = await _user.getIdTokenResult(true);
    final claims = idTokenResult.claims;
    if (claims != null) {
      return claims['admin'] == true;
    }
    return false;
  }
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth) {
    init();
  }
  final FirebaseAuth _auth;

  // This would have do be done with RxDart
  late StreamSubscription _authStateSubscription;
  final _isAdminUserSubject = BehaviorSubject<bool>.seeded(false);

  void init() {
    _authStateSubscription = authStateChanges().listen((user) async {
      if (user != null) {
        final isAdminUser = await user.isAdminUser();
        _isAdminUserSubject.add(isAdminUser);
      } else {
        _isAdminUserSubject.add(false);
      }
    });
  }

  void dispose() {
    _authStateSubscription.cancel();
  }

  @override
  Stream<bool> isAdminUserChanges() => _isAdminUserSubject.stream;

  @override
  Stream<AppUser?> authStateChanges() {
    return _auth
        .authStateChanges()
        .map((user) => user != null ? FirebaseAppUser(user) : null);
  }

  @override
  AppUser? get currentUser {
    final user = _auth.currentUser;
    return user != null ? FirebaseAppUser(user) : null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    // TODO: Handle exceptions
    return _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw const AuthException.invalidEmail();
        case 'wrong-password':
          throw const AuthException.wrongPassword();
        case 'user-not-found':
          throw const AuthException.userNotFound();
        case 'user-disabled':
          throw const AuthException.userDisabled();
        default:
          throw const AuthException.unknown();
      }
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw const AuthException.emailAlreadyInUse();
        case 'invalid-email':
          throw const AuthException.invalidEmail();
        case 'weak-password':
          throw const AuthException.weakPassword();
        case 'operation-not-allowed':
          throw const AuthException.operationNotAllowed();
        default:
          throw const AuthException.unknown();
      }
    }
  }

  @override
  Future<void> signOut() {
    return _auth.signOut();
  }
}
