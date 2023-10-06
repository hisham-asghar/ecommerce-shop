import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              final authService = ref.read(authServiceProvider);
              authService.signOut();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: const Center(
        child: UserUidLabel(),
      ),
    );
  }
}

class UserUidLabel extends ConsumerWidget {
  const UserUidLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final authStateChangesValue = ref.watch(authStateChangesProvider);
    return authStateChangesValue.when(
      data: (uid) => Text(
        'uid: $uid',
        style: Theme.of(context).textTheme.caption,
        textAlign: TextAlign.center,
      ),
      // TODO: Make this better
      // workaround for stream controller
      loading: () => Text(
        'uid: ${authService.uid}}',
        style: Theme.of(context).textTheme.caption,
        textAlign: TextAlign.center,
      ),
      error: (e, st) => Text(e.toString()),
    );
  }
}
