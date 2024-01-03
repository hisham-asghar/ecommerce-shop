import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/fake_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/search/search_repository.dart';

class FakeSearchRepository implements SearchRepository {
  FakeSearchRepository({this.addDelay = true});
  final bool addDelay;

  final List<Product> _products = [];

  // initialize with some test products
  void initWithTestProducts() {
    _products.addAll(kTestProducts);
  }

  @override
  Future<List<Product>> search(String text) async {
    await delay(addDelay);
    return _products;
  }
}
