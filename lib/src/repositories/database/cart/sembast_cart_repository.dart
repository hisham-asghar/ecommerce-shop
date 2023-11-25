import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_total.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/items_list.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/fake_cart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SembastCartRepository implements LocalCartRepository {
  static DatabaseFactory dbFactory = databaseFactoryIo;

  SembastCartRepository(this.db);
  final Database db;
  final store = StoreRef.main();

  // Create data store on predefined location
  static Future<SembastCartRepository> makeDefault() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return SembastCartRepository(
      // We use the database factory to open the database
      await dbFactory.openDatabase('${appDocDir.path}/default.db'),
    );
  }

  // Create data store on custom location
  static Future<SembastCartRepository> init(String dbPath) async =>
      SembastCartRepository(
        // We use the database factory to open the database
        await dbFactory.openDatabase(dbPath),
      );

  static const cartItemsKey = 'cartItems';

  @override
  Future<void> addItem(Item item) async {
    final itemsJson = await store.record(cartItemsKey).get(db) as String?;
    if (itemsJson != null) {
      final itemsList = ItemsList.fromJson(itemsJson);
      final fakeCart = FakeCart(itemsList.items);
      fakeCart.addItem(item);
      final newItems = ItemsList(fakeCart.items);
      await store.record(cartItemsKey).put(db, newItems.toJson());
    } else {
      final newItems = ItemsList([item]);
      await store.record(cartItemsKey).put(db, newItems.toJson());
    }
  }

  @override
  Stream<CartTotal> cartTotal(List<Product> products) {
    final record = store.record(cartItemsKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        final items = ItemsList.fromJson(snapshot.value).items;
        final total = items.isEmpty
            ? 0.0
            : items
                // first extract quantity * price for each item
                .map((item) =>
                    item.quantity * _getProduct(products, item.productId).price)
                // then add them up
                .reduce((value, element) => value + element);
        return CartTotal(total: total);
      } else {
        return CartTotal(total: 0.0);
      }
    });
  }

  Product _getProduct(List<Product> products, String id) {
    return products.firstWhere((product) => product.id == id);
  }

  @override
  Future<List<Item>> getItemsList() async {
    final itemsJson = await store.record(cartItemsKey).get(db) as String?;
    if (itemsJson != null) {
      final itemsList = ItemsList.fromJson(itemsJson);
      return itemsList.items;
    } else {
      return [];
    }
  }

  @override
  Stream<List<Item>> itemsList() {
    final record = store.record(cartItemsKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return ItemsList.fromJson(snapshot.value).items;
      } else {
        return [];
      }
    });
  }

  @override
  Future<void> removeItem(Item item) async {
    final itemsJson = await store.record(cartItemsKey).get(db) as String?;
    if (itemsJson != null) {
      final itemsList = ItemsList.fromJson(itemsJson);
      final fakeCart = FakeCart(itemsList.items);
      fakeCart.removeItem(item);
      final newItems = ItemsList(fakeCart.items);
      await store.record(cartItemsKey).put(db, newItems.toJson());
    }
  }

  @override
  Future<void> updateItemIfExists(Item item) async {
    final itemsJson = await store.record(cartItemsKey).get(db) as String?;
    if (itemsJson != null) {
      final itemsList = ItemsList.fromJson(itemsJson);
      final fakeCart = FakeCart(itemsList.items);
      if (fakeCart.updateItemIfExists(item)) {
        final newItems = ItemsList(fakeCart.items);
        await store.record(cartItemsKey).put(db, newItems.toJson());
      }
    }
  }

  @override
  Future<void> clear() async {
    await store.record(cartItemsKey).put(db, ItemsList([]).toJson());
  }
}
