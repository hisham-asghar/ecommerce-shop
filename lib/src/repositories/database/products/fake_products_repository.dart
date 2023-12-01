import 'package:faker/faker.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_assets.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/delay.dart';

class FakeProductsRepository implements ProductsRepository {
  FakeProductsRepository({this.addDelay = true});
  final bool addDelay;

  // default list of products when the app loads
  final List<Product> _products = [];
  final _productsSubject = BehaviorSubject<List<Product>>.seeded([]);
  Stream<List<Product>> get _productsStream => _productsSubject.stream;

  // initialize with some tet products
  void initWithTestProducts() {
    _products.addAll(kTestProducts);
    _productsSubject.add(_products);
  }

  @override
  Stream<List<Product>> productsList() {
    return _productsStream;
  }

  @override
  Stream<Product> product(String id) {
    return _productsStream
        .map((products) => products.firstWhere((product) => product.id == id));
  }

  @override
  Future<void> addProduct(Product product) async {
    await delay(addDelay);
    final productWithId = product.copyWith(id: const Uuid().v1());
    _products.add(productWithId);
    _productsSubject.add(_products);
  }

  @override
  Future<void> editProduct(Product product) async {
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
    imageUrl: AppAssets.sonyPlaystation4,
    title: 'Sony Playstation 4 Pro White Version',
    description: faker.lorem.sentence(),
    price: 399,
    availableQuantity: 5,
  ),
  Product(
    id: '2',
    imageUrl: AppAssets.amazonEchoDot3,
    title: 'Amazon Echo Dot 3rd Generation',
    description: faker.lorem.sentence(),
    price: 29,
    availableQuantity: 5,
  ),
  Product(
    id: '3',
    imageUrl: AppAssets.canonEos80d,
    title: 'Cannon EOS 80D DSLR Camera',
    description: faker.lorem.sentence(),
    price: 929,
    availableQuantity: 5,
  ),
  Product(
    id: '4',
    imageUrl: AppAssets.iPhone11Pro,
    title: 'iPhone 11 Pro 256GB Memory',
    description: faker.lorem.sentence(),
    price: 599,
    availableQuantity: 5,
  ),
];
