import 'package:my_shop_ecommerce_flutter/src/platform/platform_is.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/items_list.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/mutable_cart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastCartRepository implements LocalCartRepository {
  SembastCartRepository(this.db);
  final Database db;
  final store = StoreRef.main();

  // Create data store on predefined location
  static Future<SembastCartRepository> makeDefault() async {
    if (!PlatformIs.web) {
      final appDocDir = await getApplicationDocumentsDirectory();
      // We use the database factory to open the database
      final database =
          await databaseFactoryIo.openDatabase('${appDocDir.path}/default.db');
      return SembastCartRepository(database);
    } else {
      final database = await databaseFactoryWeb.openDatabase('default.db');
      return SembastCartRepository(database);
    }
  }

  static const cartItemsKey = 'cartItems';

  @override
  Future<void> addItem(Item item) async {
    final itemsJson = await store.record(cartItemsKey).get(db) as String?;
    if (itemsJson != null) {
      final itemsList = ItemsList.fromJson(itemsJson);
      final fakeCart = MutableCart(itemsList.items);
      fakeCart.addItem(item);
      final newItems = ItemsList(fakeCart.items);
      await store.record(cartItemsKey).put(db, newItems.toJson());
    } else {
      final newItems = ItemsList([item]);
      await store.record(cartItemsKey).put(db, newItems.toJson());
    }
  }

  @override
  Future<List<Item>> fetchItemsList() async {
    final itemsJson = await store.record(cartItemsKey).get(db) as String?;
    if (itemsJson != null) {
      return ItemsList.fromJson(itemsJson).items;
    } else {
      return [];
    }
  }

  @override
  Stream<List<Item>> watchItemsList() {
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
      final fakeCart = MutableCart(itemsList.items);
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
      final fakeCart = MutableCart(itemsList.items);
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
