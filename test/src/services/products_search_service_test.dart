import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/exceptions/app_exception.dart';
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
    // * Note: comparison of Results inside the stream will fail because
    // * Result is an abstract class that doesn't implement the == operator
    // expect(
    //   productSearchService.results,
    //   emitsInOrder(
    //     [
    //       // emits both results
    //       const Success<AppException, List<Product>>([]),
    //       //Success<AppException, List<Product>>([product]),
    //     ],
    //   ),
    // );
    const delay = Duration(milliseconds: 100);
    productSearchService.search('no-match');
    await Future.delayed(delay);
    final first = await productSearchService.results.first;
    expect(first.getSuccess(), []);
    productSearchService.search('match');
    await Future.delayed(delay);
    final second = await productSearchService.results.first;
    expect(second.getSuccess(), [product]);
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
    // * Note: comparison of Results inside the stream will fail because
    // * Result is an abstract class that doesn't implement the == operator
    // expect(
    //   productSearchService.results,
    //   emitsInOrder(
    //     [
    //       // only emit the last result
    //       Success<AppException, List<Product>>([product]),
    //     ],
    //   ),
    // );
    //const delay = Duration(milliseconds: 100);
    productSearchService.search('no-match');
    productSearchService.search('match');
    //await Future.delayed(delay);
    final second = await productSearchService.results.first;
    expect(second.getSuccess(), [product]);
  });

  test('When search called And exception occurrs Then emits exception',
      () async {
    final productSearchService = ProductsSearchService(
      searchFunction: (query) {
        throw const AppException.permissionDenied('');
      },
      debounceDuration: const Duration(milliseconds: 50),
    );
    // * Note: comparison of Results inside the stream will fail because
    // * Result is an abstract class that doesn't implement the == operator
    // expect(
    //   productSearchService.results,
    //   emitsInOrder(
    //     [
    //       // only emit the last result
    //       Success<AppException, List<Product>>([product]),
    //     ],
    //   ),
    // );
    //const delay = Duration(milliseconds: 100);
    productSearchService.search('match');
    //await Future.delayed(delay);
    final second = await productSearchService.results.first;
    expect(second.getError(), const AppException.permissionDenied(''));
  });
}
