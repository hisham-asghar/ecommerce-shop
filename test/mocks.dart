import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/services/admin_orders_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCartRepository extends Mock implements CartRepository {}

class MockLocalCartRepository extends Mock implements LocalCartRepository {}

class MockProductsRepository extends Mock implements ProductsRepository {}

class MockCloudFunctionsRepository extends Mock
    implements CloudFunctionsRepository {}

class MockCartService extends Mock implements CartService {}

class MockAdminOrdersService extends Mock implements AdminOrdersService {}
