import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/data/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/application/cart_service.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/application/cart_sync_service.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/local_cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/remote_cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/application/checkout_service.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/data/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/data/orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/data/reviews_repository.dart';

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
