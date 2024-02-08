import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/remote/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/reviews_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_sync_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/checkout_service.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCartRepository extends Mock implements CartRepository {}

class MockLocalCartRepository extends Mock implements LocalCartRepository {}

class MockProductsRepository extends Mock implements ProductsRepository {}

class MockCloudFunctionsRepository extends Mock
    implements CloudFunctionsRepository {}

class MockCartService extends Mock implements CartService {}

class MockCartSyncService extends Mock implements CartSyncService {}

class MockAddressRepository extends Mock implements AddressRepository {}

class MockOrdersRepository extends Mock implements OrdersRepository {}

class MockCheckoutService extends Mock implements CheckoutService {}

class MockReviewsRepository extends Mock implements ReviewsRepository {}
