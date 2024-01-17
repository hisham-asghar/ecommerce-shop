import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';

class FirebaseProductsRepository implements ProductsRepository {
  FirebaseProductsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String productsPath() => 'products';
  static String productPath(String id) => 'products/$id';

  @override
  Future<List<Product>> fetchProductsList() async {
    final ref = _productsRef();
    final snapshot =
        await ref.get(const GetOptions(source: Source.serverAndCache));
    return snapshot.docs.map((snapshot) => snapshot.data()).toList();
  }

  @override
  Stream<List<Product>> watchProductsList() {
    final ref = _productsRef();
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
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
    final ref = _productRef(id);
    return ref.snapshots().map((snapshot) => snapshot.data()!);
  }

  @override
  Future<void> createProduct(Product product) async {
    final ref = _productsRef();
    await ref.add(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final ref = _productRef(product.id);
    return ref.set(product);
  }

  DocumentReference<Product> _productRef(String id) =>
      _firestore.doc(productPath(id)).withConverter(
            fromFirestore: (doc, _) => Product.fromMap(doc.data()!, doc.id),
            toFirestore: (Product product, options) => product.toMap(),
          );

  CollectionReference<Product> _productsRef() =>
      _firestore.collection(productsPath()).withConverter(
            fromFirestore: (doc, _) => Product.fromMap(doc.data()!, doc.id),
            toFirestore: (Product product, options) => product.toMap(),
          );
}
