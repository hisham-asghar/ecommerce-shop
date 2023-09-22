import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/sign_in/email_password_sign_in_model.dart';
import 'package:my_shop_ecommerce_flutter/src/features/sign_in/email_password_sign_in_page.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';

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

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBar Widget'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                icon: Icon(Icons.beach_access_sharp),
              ),
              Tab(
                icon: Icon(Icons.brightness_5_sharp),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            EmailPasswordSignInPage(
              model: EmailPasswordSignInModel(
                authService: authService,
              ),
              onSignedIn: () {
                _tabController.index = 1;
              },
            ),
            Center(
              child: Text("It's rainy here"),
            ),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
      ),
    );
  }
}
