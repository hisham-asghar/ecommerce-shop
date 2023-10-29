import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

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
    await Future.delayed(const Duration(seconds: 1));
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
