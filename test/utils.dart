import 'package:my_shop_ecommerce_flutter/src/constants/app_assets.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';

Product makeProduct({required String id, required int availableQuantity}) =>
    Product(
      id: id,
      imageUrl: AppAssets.bruschettaPlate,
      title: 'Sony Playstation 4 Pro White Version',
      description: '1234',
      price: 399,
      availableQuantity: availableQuantity,
    );
