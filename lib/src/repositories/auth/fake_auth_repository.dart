import 'package:my_shop_ecommerce_flutter/src/models/app_user.dart';
import 'package:my_shop_ecommerce_flutter/src/models/fake_app_user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';

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
