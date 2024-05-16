import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/domain/app_user.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/domain/fake_app_user.dart';
import 'package:rxdart/rxdart.dart';

import 'package:my_shop_ecommerce_flutter/src/utils/delay.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.addDelay = true, required this.uidBuilder});
  final bool addDelay;
  final String Function() uidBuilder;

  @override
  AppUser? currentUser;

  // Problem: this won't replay the previous value when a new listener is registered
  // Use ValueNotifier instead?
  final _authState = BehaviorSubject<AppUser?>.seeded(null);

  @override
  Stream<AppUser?> authStateChanges() => _authState.stream;

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
    _authState.add(currentUser);
  }

  void dispose() => _authState.close();

  void _createNewUser() {
    currentUser = FakeAppUser(uid: uidBuilder(), email: 'test@test.com');
    _authState.add(currentUser);
  }
}
