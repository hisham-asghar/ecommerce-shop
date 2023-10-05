import 'package:faker/faker.dart' hide Address;
import 'package:my_shop_ecommerce_flutter/src/constants/app_assets.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class MockDataStore implements DataStore {
  // Address
  @override
  var isAddressSet = false;

  @override
  Future<void> submitAddress(Address address) async {
    await Future.delayed(const Duration(seconds: 2));
    isAddressSet = true;
  }

  // Products
  // default list of products when the app loads
  final List<Product> _products = kTestProducts;

  @override
  List<Product> getProducts() {
    return _products;
  }

  @override
  void addProduct(Product product) {
    throw UnimplementedError();
  }

  /// Throws error if not found
  @override
  Product findProduct(String id) {
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
  ),
  Product(
    id: '2',
    imageUrl: AppAssets.amazonEchoDot3,
    title: 'Amazon Echo Dot 3rd Generation',
    description: faker.lorem.sentence(),
    price: 29,
  ),
  Product(
    id: '3',
    imageUrl: AppAssets.canonEos80d,
    title: 'Cannon EOS 80D DSLR Camera',
    description: faker.lorem.sentence(),
    price: 929,
  ),
  Product(
    id: '4',
    imageUrl: AppAssets.iPhone11Pro,
    title: 'iPhone 11 Pro 256GB Memory',
    description: faker.lorem.sentence(),
    price: 599,
  ),
];
