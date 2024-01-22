import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';

class NotFoundScreen extends ConsumerWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '404 - Page not found!',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              const Gap(Sizes.p32),
              PrimaryButton(
                onPressed: () => context.goNamed(AppRoute.home.name),
                text: 'Go Home',
              )
            ],
          ),
        ),
      ),
    );
  }
}
