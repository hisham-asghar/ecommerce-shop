import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/app.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/mock_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/mock_cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/mock_address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/mock_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/sembast_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/mock_orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/mock_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/provider_logger.dart';

Future<void> runAppWithMocks() async {
  final authRepository = MockAuthRepository();
  final addressRepository = MockAddressRepository();
  final productsRepository = MockProductsRepository();
  final cartRepository =
      MockCartRepository(productsRepository: productsRepository);
  final ordersRepository = MockOrdersRepository(
    productsRepository: productsRepository,
    cartRepository: cartRepository,
  );
  final localCartRepository = await SembastCartRepository.makeDefault();
  final cloudFunctionsRepository =
      MockCloudFunctionsRepository(ordersRepository: ordersRepository);
  runApp(ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      addressRepositoryProvider.overrideWithValue(addressRepository),
      productsRepositoryProvider.overrideWithValue(productsRepository),
      cartRepositoryProvider.overrideWithValue(cartRepository),
      ordersRepositoryProvider.overrideWithValue(ordersRepository),
      localCartRepositoryProvider.overrideWithValue(localCartRepository),
      cloudFunctionsRepositoryProvider
          .overrideWithValue(cloudFunctionsRepository),
    ],
    observers: [ProviderLogger()],
    child: MyApp(),
  ));
}
