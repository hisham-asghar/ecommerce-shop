import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';

@immutable
class FakeAppUser implements AppUser {
  const FakeAppUser({
    required this.uid,
    this.email,
  });
  // True if user is an admin
  @override
  final String uid;

  @override
  final String? email;

  @override
  Future<bool> isAdminUser() => Future.value(true);

  FakeAppUser copyWith({
    String? uid,
    String? email,
  }) {
    return FakeAppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
    );
  }

  @override
  String toString() => 'MockAppUser(uid: $uid, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FakeAppUser && other.uid == uid && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.addDelay = true});
  final bool addDelay;

  @override
  AppUser? currentUser;

  // Problem: this won't replay the previous value when a new listener is registered
  // Use ValueNotifier instead?
  final _authStateChangesController = BehaviorSubject<AppUser?>.seeded(null);

  @override
  Stream<AppUser?> authStateChanges() => _authStateChangesController.stream;

  // Make all users admin
  @override
  Stream<bool> isAdminUserChanges() =>
      authStateChanges().map((user) => user != null);

  @override
  Future<void> signInAnonymously() async {
    await delay(addDelay);
    if (currentUser != null) {
      throw UnsupportedError(
          'User is already signed in and can\'t sign in as anonymously');
    }
    _createNewUser();
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);
    if (currentUser == null) {
      _createNewUser();
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await delay(addDelay);
    if (currentUser == null) {
      _createNewUser();
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return delay(addDelay);
  }

  @override
  Future<void> signOut() async {
    await delay(addDelay);
    currentUser = null;
    _authStateChangesController.add(currentUser);
  }

  void _createNewUser() {
    currentUser = FakeAppUser(uid: const Uuid().v1(), email: 'test@test.com');
    _authStateChangesController.add(currentUser);
  }
}
