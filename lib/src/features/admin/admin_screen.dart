import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/routing.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Center(
          child: SizedBox(
            width: FormFactor.tablet,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PrimaryButton(
                  text: 'Products',
                  onPressed: () {},
                ),
                const SizedBox(height: Sizes.p24),
                PrimaryButton(
                  text: 'Orders',
                  onPressed: () =>
                      ref.read(routerDelegateProvider).openAdminOrders(),
                ),
                // TODO: Any other options?
              ],
            ),
          ),
        ),
      ),
    );
  }
}
