import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  text: 'Manage Products',
                  onPressed: () => context.goNamed(AppRoute.adminProducts.name),
                ),
                const Gap(Sizes.p24),
                PrimaryButton(
                  text: 'Manage Orders',
                  onPressed: () => context.goNamed(AppRoute.adminOrders.name),
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
