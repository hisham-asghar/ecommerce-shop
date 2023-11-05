import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';

class CheckoutTabsController with ChangeNotifier {
  CheckoutTabsController({
    required this.currentUser,
    required this.address,
    required this.tabController,
    // set this when the object is first created.
  }) : needsTabView = currentUser == null || address == null;
  // TODO: Make this reactive again
  final AppUser? currentUser;
  final Address? address;
  final TabController tabController;
  final bool needsTabView;

  int tabIndex() {
    var tabIndex = 0;
    final user = currentUser;
    if (user != null && user.isSignedIn) {
      if (address != null) {
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
