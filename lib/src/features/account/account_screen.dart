import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/action_text_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/centered_box.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.account),
        actions: [
          ActionTextButton(
            text: context.loc.logout,
            onPressed: () async {
              final authRepository = ref.read(authRepositoryProvider);
              await authRepository.signOut();
              context.pop();
            },
          ),
        ],
      ),
      body: const CenteredBox(
        padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: UserDataTable(),
      ),
    );
  }
}

class UserDataTable extends ConsumerWidget {
  const UserDataTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChangesValue = ref.watch(authStateChangesProvider);
    final isAdminUserValue = ref.watch(isAdminUserProvider);
    final isAdminUser = isAdminUserValue.asData?.value;
    final style = Theme.of(context).textTheme.subtitle2!;
    return AsyncValueWidget<AppUser?>(
      value: authStateChangesValue,
      data: (user) => user == null
          ? const SizedBox()
          : DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    context.loc.field,
                    style: style,
                  ),
                ),
                DataColumn(
                  label: Text(
                    context.loc.value,
                    style: style,
                  ),
                ),
              ],
              rows: [
                _makeDataRow(
                  context.loc.uidLowercase,
                  user.uid,
                  style,
                ),
                _makeDataRow(
                  context.loc.emailLowercase,
                  user.email ?? '',
                  style,
                ),
                _makeDataRow(
                  context.loc.isAdminLowercase,
                  isAdminUser.toString(),
                  style,
                ),
              ],
            ),
    );
  }

  DataRow _makeDataRow(String name, String value, TextStyle style) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            name,
            style: style,
          ),
        ),
        DataCell(
          Text(
            value,
            style: style,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
