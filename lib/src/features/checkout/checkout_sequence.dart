import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_sequence_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/payment_page.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/sign_in/email_password_sign_in_model.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/sign_in/email_password_sign_in_page.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

import 'address/address_page.dart';

class CheckoutSequenceScreen extends ConsumerStatefulWidget {
  const CheckoutSequenceScreen({Key? key}) : super(key: key);

  @override
  _CheckoutSequenceState createState() => _CheckoutSequenceState();
}

class _CheckoutSequenceState extends ConsumerState<CheckoutSequenceScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);
  late final _checkoutSequenceController = CheckoutSequenceController(
    authService: ref.read(authServiceProvider),
    dataStore: ref.read(dataStoreProvider),
    tabController: _tabController,
  )..updateIndex();

  static const titles = ['Sign In', 'Address', 'Payment'];

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);
    return Scaffold(
      appBar: AppBar(
        // Use an animated builder to ensure the title updates on page transition
        title: AnimatedBuilder(
          animation: _checkoutSequenceController,
          builder: (context, _) {
            return Text(titles[_tabController.index]);
          },
        ),
        bottom: _checkoutSequenceController.needsTabView
            ? ReadOnlyTabBar(
                child: TabBar(
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      icon: const Icon(Icons.person, color: Colors.white),
                      text: titles[0],
                    ),
                    Tab(
                      icon: const Icon(Icons.map, color: Colors.white),
                      text: titles[1],
                    ),
                    Tab(
                      icon: const Icon(Icons.brightness_5_sharp,
                          color: Colors.white),
                      text: titles[2],
                    ),
                  ],
                ),
              )
            : null,
      ),
      body: _checkoutSequenceController.needsTabView
          ? TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: <Widget>[
                EmailPasswordSignInPage(
                  model: EmailPasswordSignInModel(authService: authService),
                  onSignedIn: () => _checkoutSequenceController.updateIndex(),
                ),
                AddressPage(
                  onDataSubmitted: () =>
                      _checkoutSequenceController.updateIndex(),
                ),
                const PaymentPage(),
              ],
            )
          : const PaymentPage(),
    );
  }
}

// https://stackoverflow.com/a/57354375/436422
class ReadOnlyTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabBar child;

  const ReadOnlyTabBar({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: child);
  }

  @override
  Size get preferredSize => child.preferredSize;
}
