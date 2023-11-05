import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_tabs_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/payment_page.dart';
import 'package:my_shop_ecommerce_flutter/src/features/sign_in/email_password_sign_in_model.dart';
import 'package:my_shop_ecommerce_flutter/src/features/sign_in/email_password_sign_in_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'address/address_page.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressValue = ref.watch(addressProvider);
    return AsyncValueWidget<Address?>(
      value: addressValue,
      data: (address) => CheckoutScreenContents(address: address),
    );
  }
}

class CheckoutScreenContents extends ConsumerStatefulWidget {
  const CheckoutScreenContents({Key? key, required this.address})
      : super(key: key);
  final Address? address;

  @override
  _CheckoutScreenContentsState createState() => _CheckoutScreenContentsState();
}

class _CheckoutScreenContentsState extends ConsumerState<CheckoutScreenContents>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);
  // TODO: This is not reactive
  late final _checkoutTabsController = CheckoutTabsController(
    currentUser: ref.read(authServiceProvider).currentUser,
    address: widget.address,
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
          EmailPasswordSignInContents(
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
