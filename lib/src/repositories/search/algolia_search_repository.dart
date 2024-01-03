import 'package:algolia/algolia.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/search/search_repository.dart';

class AlgoliaSearchRepository implements SearchRepository {
  const AlgoliaSearchRepository(this._algolia);
  final Algolia _algolia;

  @override
  Future<List<Product>> search(String text) async {
    final index = _algolia.index('products');
    final query = index.query(text);
    final objects = await query.getObjects();
    return objects.hits
        .map((hit) => Product.fromMap(hit.data, hit.objectID))
        .toList();
  }
}
