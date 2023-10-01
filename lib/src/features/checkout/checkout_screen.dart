import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_tabs_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/payment_page.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/sign_in/email_password_sign_in_model.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/sign_in/email_password_sign_in_page.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

import 'address/address_page.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);
  late final _checkoutTabsController = CheckoutTabsController(
    authService: ref.read(authServiceProvider),
    dataStore: ref.read(dataStoreProvider),
    tabController: _tabController,
  )..updateIndex();

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);
    if (_checkoutTabsController.needsTabView) {
      return CheckoutWithTabs(
        tabController: _tabController,
        checkoutSequenceController: _checkoutTabsController,
        authService: authService,
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: PaymentPage(),
      );
    }
  }
}

class CheckoutWithTabs extends StatelessWidget {
  const CheckoutWithTabs({
    Key? key,
    required this.tabController,
    required this.checkoutSequenceController,
    required this.authService,
  }) : super(key: key);
  final TabController tabController;
  final CheckoutTabsController checkoutSequenceController;
  final AuthService authService;

  static const titles = ['Sign In', 'Address', 'Payment'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Use an animated builder to ensure the title updates on page transition
        title: AnimatedBuilder(
          animation: checkoutSequenceController,
          builder: (context, _) {
            return Text(titles[tabController.index]);
          },
        ),
        bottom: ReadOnlyTabBar(
          child: TabBar(
            controller: tabController,
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
                icon: const Icon(Icons.brightness_5_sharp, color: Colors.white),
                text: titles[2],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: <Widget>[
          EmailPasswordSignInPage(
            model: EmailPasswordSignInModel(authService: authService),
            onSignedIn: () => checkoutSequenceController.updateIndex(),
          ),
          AddressPage(
            onDataSubmitted: () => checkoutSequenceController.updateIndex(),
          ),
          PaymentPage(),
        ],
      ),
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
