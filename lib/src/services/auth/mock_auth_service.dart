import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'package:my_shop_ecommerce_flutter/src/services/auth/auth_service.dart';

class MockAppUser implements AppUser {
  MockAppUser({
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

  MockAppUser copyWith({
    String? uid,
    String? email,
  }) {
    return MockAppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
    );
  }

  @override
  String toString() => 'MockAppUser(uid: $uid, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MockAppUser && other.uid == uid && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;
}

class MockAuthService implements AuthService {
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
    await Future.delayed(const Duration(seconds: 1));
    if (currentUser != null) {
      throw UnsupportedError(
          'User is already signed in and can\'t sign in as anonymously');
    }
    _createNewUser();
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (currentUser == null) {
      _createNewUser();
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (currentUser == null) {
      _createNewUser();
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 2));
    currentUser = null;
  }

  void _createNewUser() {
    currentUser = MockAppUser(
      uid: const Uuid().v1(),
    );
    _authStateChangesController.add(currentUser);
    print('New uid: ${currentUser!.uid}');
  }
}
