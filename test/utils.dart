import 'package:my_shop_ecommerce_flutter/src/constants/app_assets.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';

Product makeProduct(String id, int quantity) => Product(
      id: id,
      imageUrl: AppAssets.sonyPlaystation4,
      title: 'Sony Playstation 4 Pro White Version',
      description: '1234',
      price: 399,
      availableQuantity: quantity,
    );
