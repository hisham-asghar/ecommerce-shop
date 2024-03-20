import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/alert_dialogs.dart';

typedef VoidAsyncValue = AsyncValue<void>;

extension AsyncValueUI on VoidAsyncValue {
  void showAlertDialogOnError(BuildContext context) => whenOrNull(
        error: (error, _) {
          showExceptionAlertDialog(
            context: context,
            title: 'Error',
            exception: error,
          );
        },
      );
}
