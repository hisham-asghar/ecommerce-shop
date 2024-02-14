import 'package:my_shop_ecommerce_flutter/src/constants/test_products.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

Product makeProduct({required String id, required int availableQuantity}) =>
    Product(
      id: id,
      imageUrl: kTestProducts[0].imageUrl,
      title: 'Bruschetta plate',
      description: 'Lorem ipsum',
      price: 399,
      availableQuantity: availableQuantity,
    );
