import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/services/products_search_service.dart';

import '../../utils.dart';

void main() {
  test('When search called twice over debounce period Then emits two results',
      () async {
    final product = makeProduct(id: '123', availableQuantity: 10);
    final productSearchService = ProductsSearchService(
      searchFunction: (query) {
        if (query == 'match') {
          return Future.value([product]);
        } else {
          return Future.value([]);
        }
      },
      debounceDuration: const Duration(milliseconds: 50),
    );
    expect(
      productSearchService.results,
      emitsInOrder(
        [
          // emits both results
          [],
          [product],
        ],
      ),
    );
    const delay = Duration(milliseconds: 100);
    productSearchService.search('no-match');
    await Future.delayed(delay);
    productSearchService.search('match');
    await Future.delayed(delay);
  });

  test('When search called twice within debounce period Then emits one result',
      () async {
    final product = makeProduct(id: '123', availableQuantity: 10);
    final productSearchService = ProductsSearchService(
      searchFunction: (query) {
        if (query == 'match') {
          return Future.value([product]);
        } else {
          return Future.value([]);
        }
      },
      debounceDuration: const Duration(milliseconds: 50),
    );
    expect(
      productSearchService.results,
      emitsInOrder(
        [
          // only emit the last result
          [product],
        ],
      ),
    );
    const delay = Duration(milliseconds: 100);
    productSearchService.search('no-match');
    productSearchService.search('match');
    await Future.delayed(delay);
  });
}
