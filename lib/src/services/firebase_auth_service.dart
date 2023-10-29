import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart'
    as auth;

class FirebaseAuthService implements auth.AuthService {
  final _auth = FirebaseAuth.instance;
  @override
  Stream<auth.User?> authStateChanges() {
    return _auth.authStateChanges().map((user) => user != null
        ? auth.User(
            uid: user.uid,
            isSignedIn: !user.isAnonymous,
            isAdmin: false,
          )
        : null);
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  auth.User? get currentUser {
    final user = _auth.currentUser;
    return user != null
        ? auth.User(
            uid: user.uid,
            isSignedIn: !user.isAnonymous,
            isAdmin: false,
          )
        : null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signInAnonymously() {
    return _auth.signInAnonymously();
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() {
    return _auth.signOut();
  }
}
