import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
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
      yield await searchFunction(query);
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
  late Stream<List<Product>> _results;
  Stream<List<Product>> get results => _results;

  void dispose() {
    _searchTerms.close();
  }
}

final productsSearchServiceProvider =
    Provider.autoDispose<ProductsSearchService>((ref) {
  final searchRepository = ref.watch(searchRepositoryProvider);
  final searchService =
      ProductsSearchService(searchFunction: searchRepository.searchProducts);
  ref.onDispose(() => searchService.dispose());
  return searchService;
});

final productsSearchResultsProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  final searchService = ref.watch(productsSearchServiceProvider);
  return searchService.results;
});
