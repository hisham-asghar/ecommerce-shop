import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/action_text_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ActionTextButton(
            text: 'Logout',
            onPressed: () async {
              final authRepository = ref.read(authRepositoryProvider);
              await authRepository.signOut();
              context.pop();
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
    final isAdminUserValue = ref.watch(isAdminUserProvider);
    final isAdminUser = isAdminUserValue.asData?.value;

    return AsyncValueWidget<AppUser?>(
      value: authStateChangesValue,
      data: (user) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'uid: ${user?.uid}',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sizes.p16),
          Text(
            'email: ${user?.email}',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sizes.p16),
          Text(
            'isAdmin: $isAdminUser',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
