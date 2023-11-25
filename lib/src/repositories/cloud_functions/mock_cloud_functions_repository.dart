import 'package:my_shop_ecommerce_flutter/src/entities/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/data_store/mock_data_store.dart';

class MockCloudFunctionsRepository implements CloudFunctionsRepository {
  MockCloudFunctionsRepository(this.dataStore);
  final MockDataStore dataStore;

  @override
  Future<Order> placeOrder(String uid) async {
    return await dataStore.placeOrder(uid);
  }
}
