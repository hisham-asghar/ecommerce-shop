import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.adminDashboard),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Center(
          child: SizedBox(
            width: Breakpoint.tablet,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PrimaryButton(
                  text: context.loc.manageProducts,
                  onPressed: () => context.goNamed(AppRoute.adminProducts.name),
                ),
                gapH24,
                PrimaryButton(
                  text: context.loc.manageOrders,
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
