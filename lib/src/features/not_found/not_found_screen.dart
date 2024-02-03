import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/not_found/empty_placeholder_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';

/// Simple not found screen used for 404 errors (page not found on web)
class NotFoundScreen extends ConsumerWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: EmptyPlaceholderWidget(
        message: context.loc.notFound404,
      ),
    );
  }
}
