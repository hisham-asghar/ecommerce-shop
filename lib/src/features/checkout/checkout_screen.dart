import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/address/address_page.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen_state.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/payment_page.dart';
import 'package:my_shop_ecommerce_flutter/src/features/sign_in/email_password_sign_in_model.dart';
import 'package:my_shop_ecommerce_flutter/src/features/sign_in/email_password_sign_in_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    ref.listen<CheckoutScreenState>(checkoutScreenControllerProvider,
        (_, state) {
      state.maybeWhen(
          tab: (index) {
            _tabController.index = index;
          },
          orElse: () {});
    });
    final state = ref.watch(checkoutScreenControllerProvider);
    return state.when(
      noTabs: () => Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: const PaymentPage(),
      ),
      tab: (index) => CheckoutWithTabs(
        tabController: _tabController,
        tabIndex: index,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
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
              authService: ref.watch(authRepositoryProvider),
              formType: EmailPasswordSignInFormType.register,
            ),
            onSignedIn: () async {
              try {
                await ref.read(cartServiceProvider).copyItemsToRemote();
              } catch (e, _) {
                // TODO: Report exception
                debugPrint(e.toString());
              }
            },
          ),
          const AddressPage(),
          const PaymentPage(),
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
