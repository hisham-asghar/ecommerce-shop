import 'package:faker/faker.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_assets.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';

class FakeProductsRepository implements ProductsRepository {
  FakeProductsRepository({this.addDelay = true});
  final bool addDelay;

  // default list of products when the app loads
  final List<Product> _products = [];
  final _productsSubject = BehaviorSubject<List<Product>>.seeded([]);
  Stream<List<Product>> get _productsStream => _productsSubject.stream;

  // initialize with some test products
  void initWithTestProducts() {
    _products.addAll(kTestProducts);
    _productsSubject.add(_products);
  }

  @override
  Future<List<Product>> fetchProductsList() {
    return Future.value(_products);
  }

  @override
  Stream<List<Product>> watchProductsList() {
    return _productsStream;
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
  Stream<Product> product(String id) {
    return _productsStream
        .map((products) => products.firstWhere((product) => product.id == id));
  }

  @override
  Future<void> createProduct(Product product) async {
    await delay(addDelay);
    final productWithId = product.copyWith(id: const Uuid().v1());
    _products.add(productWithId);
    _productsSubject.add(_products);
  }

  @override
  Future<void> updateProduct(Product product) async {
    await delay(addDelay);
    final index = _products.indexWhere((item) => item.id == product.id);
    if (index == -1) {
      throw AssertionError('Product not found (id: ${product.id}');
    }
    _products[index] = product;
    _productsSubject.add(_products);
  }

  Product getProduct(String id) {
    /// Throws error if not found
    return _products.firstWhere((product) => product.id == id);
  }
}

final faker = Faker();
final kTestProducts = [
  Product(
    id: '1',
    imageUrl: AppAssets.bruschettaPlate,
    title: 'Bruschetta plate',
    description: faker.lorem.sentence(),
    price: 15,
    availableQuantity: 5,
  ),
  Product(
    id: '2',
    imageUrl: AppAssets.mozzarellaPlate,
    title: 'Mozzarella plate',
    description: faker.lorem.sentence(),
    price: 13,
    availableQuantity: 5,
  ),
  Product(
    id: '3',
    imageUrl: AppAssets.pastaPlate,
    title: 'Pasta plate',
    description: faker.lorem.sentence(),
    price: 17,
    availableQuantity: 5,
  ),
  Product(
    id: '4',
    imageUrl: AppAssets.piggyBankBlue,
    title: 'Piggy Bank Blue',
    description: faker.lorem.sentence(),
    price: 12,
    availableQuantity: 5,
  ),
];
