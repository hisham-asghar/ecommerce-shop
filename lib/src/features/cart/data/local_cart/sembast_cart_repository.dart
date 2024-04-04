import 'package:flutter/foundation.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/data/local_cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/cart.dart';
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
    if (!kIsWeb) {
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
  Future<Cart> fetchCart() async {
    final cartJson = await store.record(cartItemsKey).get(db) as String?;
    if (cartJson != null) {
      return Cart.fromJson(cartJson);
    } else {
      return const Cart();
    }
  }

  @override
  Stream<Cart> watchCart() {
    final record = store.record(cartItemsKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return Cart.fromJson(snapshot.value);
      } else {
        return const Cart();
      }
    });
  }

  @override
  Future<void> setCart(Cart cart) async {
    await store.record(cartItemsKey).put(db, cart.toJson());
  }
}
