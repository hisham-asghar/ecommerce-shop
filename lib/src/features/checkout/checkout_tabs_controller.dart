import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class CheckoutTabsController with ChangeNotifier {
  CheckoutTabsController({
    required this.authService,
    required this.dataStore,
    required this.tabController,
    // set this when the object is first created.
  }) : needsTabView = authService.currentUser == null ||
            dataStore.getAddress(authService.currentUser!.uid) == null;
  final AuthService authService;
  final DataStore dataStore;
  final TabController tabController;
  final bool needsTabView;

  int tabIndex() {
    var tabIndex = 0;
    final user = authService.currentUser;
    if (user != null && user.isSignedIn) {
      if (dataStore.getAddress(user.uid) != null) {
        tabIndex = 2;
      } else {
        tabIndex = 1;
      }
    }
    return tabIndex;
  }

  void updateIndex() {
    tabController.index = tabIndex();
    notifyListeners();
  }
}
