import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/domain/app_user.dart';

class AuthStateNotifier extends ChangeNotifier {
  AuthStateNotifier({required this.authStateChanges}) {
    _authStateSubscription = authStateChanges.listen((appUser) {
      _isLoggedIn = appUser != null;
      notifyListeners();
    });
  }
  final Stream<AppUser?> authStateChanges;
  late final StreamSubscription<AppUser?> _authStateSubscription;
  var _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }
}

final authStateNotifierProvider =
    ChangeNotifierProvider<AuthStateNotifier>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final result = AuthStateNotifier(
    authStateChanges: authRepository.authStateChanges(),
  );
  ref.onDispose(() => result.dispose());
  return result;
});
