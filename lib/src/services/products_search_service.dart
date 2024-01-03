import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/search/search_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProductsSearchService {
  ProductsSearchService({required this.searchRepository}) {
    _results = _searchTerms
        .debounce((_) => TimerStream(true, const Duration(milliseconds: 400)))
        .switchMap((query) async* {
      yield await searchRepository.search(query);
    });
    // on load, search for empty string to get all products
    search('');
  }
  final SearchRepository searchRepository;

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
      ProductsSearchService(searchRepository: searchRepository);
  ref.onDispose(() => searchService.dispose());
  return searchService;
});

final productsSearchResultsProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  final searchService = ref.watch(productsSearchServiceProvider);
  return searchService.results;
});
