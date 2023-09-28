import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class PurchaseSequenceController with ChangeNotifier {
  PurchaseSequenceController({
    required this.authService,
    required this.dataStore,
    required this.tabController,
  });
  final AuthService authService;
  final DataStore dataStore;
  final TabController tabController;

  int tabIndex() {
    var tabIndex = 0;
    if (authService.isSignedIn) {
      if (dataStore.isAddressSet) {
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
