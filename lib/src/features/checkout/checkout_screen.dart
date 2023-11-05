import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen_model.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen_model_state.dart';
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

  @override
  Widget build(BuildContext context) {
    ref.listen(checkoutScreenModelProvider, (CheckoutScreenModelState state) {
      state.maybeWhen(
          tab: (index) {
            _tabController.index = index;
          },
          orElse: () {});
    });
    final checkoutScreenModelState = ref.watch(checkoutScreenModelProvider);
    return checkoutScreenModelState.when(
      noTabs: () => Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: PaymentPage(),
      ),
      tab: (index) => CheckoutWithTabs(
        tabController: _tabController,
        tabIndex: index,
      ),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class CheckoutWithTabs extends ConsumerWidget {
  const CheckoutWithTabs({
    Key? key,
    required this.tabController,
    required this.tabIndex,
  }) : super(key: key);
  final TabController tabController;
  final int tabIndex;

  static const titles = ['Sign In', 'Address', 'Payment'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // Use an animated builder to ensure the title updates on page transition
        title: Text(titles[tabController.index]),
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
            model: EmailPasswordSignInModel(
              authService: ref.watch(authServiceProvider),
            ),
          ),
          const AddressPage(),
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
