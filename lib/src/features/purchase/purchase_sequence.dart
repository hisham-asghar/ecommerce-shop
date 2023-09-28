import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/purchase/payment/payment_page.dart';
import 'package:my_shop_ecommerce_flutter/src/features/purchase/purchase_sequence_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/purchase/sign_in/email_password_sign_in_model.dart';
import 'package:my_shop_ecommerce_flutter/src/features/purchase/sign_in/email_password_sign_in_page.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

import 'address/address_page.dart';

class PurchaseSequence extends ConsumerStatefulWidget {
  const PurchaseSequence({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const PurchaseSequence(),
      fullscreenDialog: true,
    );
  }

  @override
  _PurchaseSequenceState createState() => _PurchaseSequenceState();
}

class _PurchaseSequenceState extends ConsumerState<PurchaseSequence>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);
  late final _purchaseSequenceController = PurchaseSequenceController(
    authService: ref.read(authServiceProvider),
    dataStore: ref.read(dataStoreProvider),
    tabController: _tabController,
  )..updateIndex();

  static const titles = ['Sign In', 'Address', 'Payment'];

  // Order returned when the payment is complete
  // It's ok to store this as local state as we expect the user to dismiss the page afterwards
  Order? _order;
  bool get didCompleteOrder => _order != null;

  Future<void> _handleOrderCompleted(Order order) async {
    setState(() => _order = order);
  }

  void _onClose() {
    if (_order != null) {
      // TODO: Choose based on route name (only dismiss up to shopping bag)
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _onClose,
        ),
        // Use an animated builder to ensure the title updates on page transition
        title: AnimatedBuilder(
          animation: _purchaseSequenceController,
          builder: (context, _) {
            return Text(titles[_tabController.index]);
          },
        ),
        bottom: _purchaseSequenceController.needsTabView
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
      body: _purchaseSequenceController.needsTabView
          ? TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: <Widget>[
                EmailPasswordSignInPage(
                  model: EmailPasswordSignInModel(authService: authService),
                  onSignedIn: () => _purchaseSequenceController.updateIndex(),
                ),
                AddressPage(
                  onDataSubmitted: () =>
                      _purchaseSequenceController.updateIndex(),
                ),
                PaymentPage(
                  order: _order,
                  onOrderCompleted: _handleOrderCompleted,
                ),
              ],
            )
          : PaymentPage(
              order: _order,
              onOrderCompleted: _handleOrderCompleted,
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
