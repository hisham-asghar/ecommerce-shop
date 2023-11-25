import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/mock_orders_repository.dart';

class MockCloudFunctionsRepository implements CloudFunctionsRepository {
  MockCloudFunctionsRepository({required this.ordersRepository});
  final MockOrdersRepository ordersRepository;

  @override
  Future<Order> placeOrder(String uid) async {
    return await ordersRepository.placeOrder(uid);
  }
}
