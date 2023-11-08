import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'package:my_shop_ecommerce_flutter/src/services/auth/auth_service.dart';

class MockAppUser implements AppUser {
  MockAppUser({
    required this.uid,
    required this.isAdmin,
  });
  // True if user is an admin
  @override
  final String uid;

  // True if user is an admin
  @override
  final bool isAdmin;

  MockAppUser copyWith({
    String? uid,
    bool? isAdmin,
  }) {
    return MockAppUser(
      uid: uid ?? this.uid,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  @override
  String toString() => 'MockAppUser(uid: $uid, isAdmin: $isAdmin)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MockAppUser && other.uid == uid && other.isAdmin == isAdmin;
  }

  @override
  int get hashCode => uid.hashCode ^ isAdmin.hashCode;
}

class MockAuthService implements AuthService {
  @override
  AppUser? currentUser;

  // Problem: this won't replay the previous value when a new listener is registered
  // Use ValueNotifier instead?
  final _authStateChangesController = BehaviorSubject<AppUser?>.seeded(null);

  @override
  Stream<AppUser?> authStateChanges() => _authStateChangesController.stream;

  @override
  Future<void> signInAnonymously() async {
    await Future.delayed(const Duration(seconds: 1));
    if (currentUser != null) {
      throw UnsupportedError(
          'User is already signed in and can\'t sign in as anonymously');
    }
    _createNewUser(isAdmin: false);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (currentUser == null) {
      _createNewUser(isAdmin: true);
    } else {
      _updateUser(isAdmin: true);
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (currentUser == null) {
      _createNewUser(isAdmin: true);
    } else {
      _updateUser(isAdmin: true);
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

  void _createNewUser({required bool isAdmin}) {
    currentUser = MockAppUser(
      uid: const Uuid().v1(),
      isAdmin: isAdmin,
    );
    _authStateChangesController.add(currentUser);
    print('New uid: ${currentUser!.uid}');
  }

  void _updateUser({required bool isAdmin}) {
    currentUser = (currentUser as MockAppUser?)!.copyWith(
      isAdmin: isAdmin,
    );
    _authStateChangesController.add(currentUser);
    print('New uid: ${currentUser!.uid}');
  }
}
