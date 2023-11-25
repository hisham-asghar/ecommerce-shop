import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/fake_orders_repository.dart';

class FakeCloudFunctionsRepository implements CloudFunctionsRepository {
  FakeCloudFunctionsRepository({required this.ordersRepository});
  final FakeOrdersRepository ordersRepository;

  @override
  Future<Order> placeOrder(String uid) async {
    return await ordersRepository.placeOrder(uid);
  }
}
