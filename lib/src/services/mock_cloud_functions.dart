import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cloud_functions.dart';
import 'package:my_shop_ecommerce_flutter/src/services/mock_data_store.dart';

class MockCloudFunctions implements CloudFunctions {
  MockCloudFunctions(this.dataStore);
  final MockDataStore dataStore;

  @override
  Future<Order> placeOrder(String uid) async {
    return await dataStore.placeOrder(uid);
  }
}
