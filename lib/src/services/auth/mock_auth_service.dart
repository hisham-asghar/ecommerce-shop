import 'package:my_shop_ecommerce_flutter/src/services/auth/auth_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class MockAppUser implements AppUser {
  MockAppUser({
    required this.uid,
    required this.isSignedIn,
    required this.isAdmin,
  });
  // True if user is an admin
  @override
  final String uid;
  // Temporary getter, will replace with Firebase stull
  // if true, user is authenticated
  // if false, user is guest (anonymous)
  @override
  final bool isSignedIn;
  // True if user is an admin
  @override
  final bool isAdmin;

  MockAppUser copyWith({
    String? uid,
    bool? isSignedIn,
    bool? isAdmin,
  }) {
    return MockAppUser(
      uid: uid ?? this.uid,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  @override
  String toString() =>
      'User(uid: $uid, isSignedIn: $isSignedIn, isAdmin: $isAdmin)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.uid == uid &&
        other.isSignedIn == isSignedIn &&
        other.isAdmin == isAdmin;
  }

  @override
  int get hashCode => uid.hashCode ^ isSignedIn.hashCode ^ isAdmin.hashCode;
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
    currentUser = MockAppUser(
      uid: const Uuid().v1(),
      isSignedIn: isSignedIn,
      isAdmin: isAdmin,
    );
    _authStateChangesController.add(currentUser);
    print('New uid: ${currentUser!.uid}');
  }

  void _updateUser({required bool isSignedIn, required bool isAdmin}) {
    currentUser = (currentUser as MockAppUser?)!.copyWith(
      isSignedIn: isSignedIn,
      isAdmin: isAdmin,
    );
    _authStateChangesController.add(currentUser);
    print('New uid: ${currentUser!.uid}');
  }
}
