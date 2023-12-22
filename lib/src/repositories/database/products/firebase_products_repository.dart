import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';

class FirebaseProductsRepository implements ProductsRepository {
  FirebaseProductsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String productsPath() => 'products';
  static String productPath(String id) => 'products/$id';

  @override
  Future<List<Product>> getProductsList() async {
    final ref = _productsRef();
    final snapshot = await ref.get();
    return snapshot.docs.map((snapshot) => snapshot.data()).toList();
  }

  @override
  Stream<List<Product>> productsList() {
    final ref = _productsRef();
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  @override
  Stream<Product> product(String id) {
    final ref = _productRef(id);
    return ref.snapshots().map((snapshot) => snapshot.data()!);
  }

  @override
  Future<void> addProduct(Product product) async {
    final ref = _productsRef();
    await ref.add(product);
  }

  @override
  Future<void> editProduct(Product product) async {
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
