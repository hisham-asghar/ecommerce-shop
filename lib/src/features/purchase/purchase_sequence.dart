import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/purchase/sign_in/email_password_sign_in_model.dart';
import 'package:my_shop_ecommerce_flutter/src/features/purchase/sign_in/email_password_sign_in_page.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';

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

  static const titles = ['Sign In', 'Address', 'Payment'];
  var title = 'Sign In';

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_tabController.index]),
        bottom: ReadOnlyTabBar(
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
                icon: const Icon(Icons.brightness_5_sharp, color: Colors.white),
                text: titles[2],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[
          EmailPasswordSignInPage(
            model: EmailPasswordSignInModel(authService: authService),
            onSignedIn: () {
              // Increment index to show next page in sequence
              _tabController.index = 1;
            },
          ),
          AddressPage(
            onDataSubmitted: () {
              _tabController.index = 2;
            },
          ),
          // TODO: Payment
          Center(
            child: Text("It's sunny here"),
          ),
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
