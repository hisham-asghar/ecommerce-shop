import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';

class FirebaseAppUser implements AppUser {
  FirebaseAppUser(this._user);
  final User _user;
  @override
  bool get isAdmin => false;

  @override
  bool get isSignedIn => !_user.isAnonymous;

  @override
  String get uid => _user.uid;
}

class FirebaseAuthService implements AuthService {
  final _auth = FirebaseAuth.instance;
  @override
  Stream<AppUser?> authStateChanges() {
    return _auth
        .authStateChanges()
        .map((user) => user != null ? FirebaseAppUser(user) : null);
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    // TODO: how to link with credential when registering?
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  AppUser? get currentUser {
    final user = _auth.currentUser;
    return user != null ? FirebaseAppUser(user) : null;
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
    // Assuming the user is always signed in anonymously,
    // this method should link the existing account with the email auth credential
    // final user = _auth.currentUser!;
    // await user.linkWithCredential(
    //     EmailAuthProvider.credential(email: email, password: password));
    // TODO: This is broken!!
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await _auth.signInAnonymously();
  }
}
