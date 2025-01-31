import 'package:my_shop_ecommerce_flutter/src/constants/test_products.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/domain/product.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/delay.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/in_memory_store.dart';
import 'package:uuid/uuid.dart';

class FakeProductsRepository implements ProductsRepository {
  FakeProductsRepository({this.addDelay = true});
  final bool addDelay;

  // default list of products when the app loads
  final _products = InMemoryStore<List<Product>>([]);

  // initialize with some test products
  void initWithTestProducts() {
    // * Using List.from to convert to a mutable list
    _products.value = List.from(kTestProducts);
  }

  @override
  Future<List<Product>> fetchProductsList() {
    return Future.value(_products.value);
  }

  @override
  Stream<List<Product>> watchProductsList() {
    return _products.stream;
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    // 1. Get all products from server
    final productsList = await fetchProductsList();
    // 2. Perform filtering client-side
    return productsList
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Stream<Product?> product(String id) {
    return _products.stream
        .map((products) => products.firstWhere((product) => product.id == id));
  }

  @override
  Future<void> createProduct(Product product) async {
    await delay(addDelay);
    final productWithId = product.copyWith(id: const Uuid().v1());
    final value = _products.value;
    value.add(productWithId);
    _products.value = value;
  }

  @override
  Future<void> updateProduct(Product product) async {
    await delay(addDelay);
    final value = _products.value;
    final index = value.indexWhere((item) => item.id == product.id);
    if (index == -1) {
      throw AssertionError('Product not found (id: ${product.id}');
    }
    value[index] = product;
    _products.value = value;
  }

  Product getProduct(String id) {
    /// Throws error if not found
    return _products.value.firstWhere((product) => product.id == id);
  }
}
