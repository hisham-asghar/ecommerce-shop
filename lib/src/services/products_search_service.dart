import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_provider.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/exceptions/app_exception.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/search/search_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProductsSearchService {
  ProductsSearchService({
    required this.searchFunction,
    this.debounceDuration = const Duration(milliseconds: 250),
  }) {
    _results = _searchTerms
        .debounce((_) => TimerStream(true, debounceDuration))
        .switchMap((query) async* {
      try {
        final result = await searchFunction(query);
        yield Success(result);
      } on AppException catch (e) {
        yield Error(e);
      }
    });
    // on load, search for empty string to get all products
    search('');
  }
  final Future<List<Product>> Function(String) searchFunction;
  final Duration debounceDuration;

  // Input stream (search terms)
  final _searchTerms = BehaviorSubject<String>();
  void search(String query) => _searchTerms.add(query);

  // Output stream (search results)
  late Stream<Result<AppException, List<Product>>> _results;
  Stream<Result<AppException, List<Product>>> get results => _results;

  void dispose() {
    _searchTerms.close();
  }
}

final productsSearchServiceProvider =
    Provider.autoDispose<ProductsSearchService>((ref) {
  final searchRepository = ref.watch(searchRepositoryProvider);
  final searchService = ProductsSearchService(
    searchFunction: searchRepository.searchProducts,
  );
  ref.onDispose(() => searchService.dispose());
  return searchService;
});

final productsSearchResultsProvider =
    StreamProvider.autoDispose<Result<String, List<Product>>>((ref) {
  final searchService = ref.watch(productsSearchServiceProvider);
  final localizations = ref.watch(appLocalizationsProvider);
  // Map the error to a string
  return searchService.results.map(
    (result) => result.when(
      (error) => Error(error.message(localizations)),
      (success) => Success(success),
    ),
  );
});
