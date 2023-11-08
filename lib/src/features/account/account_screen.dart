import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/action_text_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth/auth_service.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ActionTextButton(
            text: 'Logout',
            onPressed: () {
              final authService = ref.read(authServiceProvider);
              authService.signOut();
            },
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
    final authStateChangesValue = ref.watch(authStateChangesProvider);
    return AsyncValueWidget(
      value: authStateChangesValue,
      data: (uid) => Text(
        'uid: $uid',
        style: Theme.of(context).textTheme.caption,
        textAlign: TextAlign.center,
      ),
    );
  }
}
