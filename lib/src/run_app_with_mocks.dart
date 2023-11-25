import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/app.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/fake_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/fake_cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/fake_address_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/fake_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/sembast_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/fake_orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/fake_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/provider_logger.dart';

Future<void> runAppWithMocks() async {
  final authRepository = FakeAuthRepository();
  final addressRepository = FakeAddressRepository();
  final productsRepository = FakeProductsRepository();
  final cartRepository =
      FakeCartRepository(productsRepository: productsRepository);
  final ordersRepository = FakeOrdersRepository(
    productsRepository: productsRepository,
    cartRepository: cartRepository,
  );
  final localCartRepository = await SembastCartRepository.makeDefault();
  final cloudFunctionsRepository =
      FakeCloudFunctionsRepository(ordersRepository: ordersRepository);
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
