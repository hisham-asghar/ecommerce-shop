import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cloud_functions/cloud_functions_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/local_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/services/products_service.dart';
import 'package:rxdart/rxdart.dart';

class CartService {
  CartService(
      {required this.authRepository,
      required this.cartRepository,
      required this.localCartRepository,
      required this.cloudFunctions});
  final AuthRepository authRepository;
  final CartRepository cartRepository;
  final LocalCartRepository localCartRepository;
  final CloudFunctionsRepository cloudFunctions;

  Future<List<Item>> getItemsList() {
    final user = authRepository.currentUser;
    if (user != null) {
      return cartRepository.getItemsList(user.uid);
    } else {
      return localCartRepository.getItemsList();
    }
  }

  Future<void> addItem(Item item) {
    final user = authRepository.currentUser;
    if (user != null) {
      // This will replace the item quantity if it already exists
      return cartRepository.addItem(user.uid, item);
    } else {
      return localCartRepository.addItem(item);
    }
  }

  Future<void> removeItem(Item item) {
    final user = authRepository.currentUser;
    if (user != null) {
      return cartRepository.removeItem(user.uid, item);
    } else {
      return localCartRepository.removeItem(item);
    }
  }

  Future<void> updateItemIfExists(Item item) {
    // Is there a way to cache this so updates are faster?
    final user = authRepository.currentUser;
    if (user != null) {
      return cartRepository.updateItemIfExists(user.uid, item);
    } else {
      return localCartRepository.updateItemIfExists(item);
    }
  }

  Future<void> copyItemsToRemote() async {
    final user = authRepository.currentUser;
    if (user != null) {
      try {
        final items = await localCartRepository.getItemsList();
        await cartRepository.addAllItems(user.uid, items);
        await localCartRepository.clear();
      } catch (e, _) {
        // TODO: Report error
        print(e);
      }
    } else {
      throw AssertionError('user uid == null');
    }
  }
}

final cartServiceProvider = Provider<CartService>((ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  final localCartRepository = ref.watch(localCartRepositoryProvider);
  final authService = ref.watch(authRepositoryProvider);
  final cloudFunctions = ref.watch(cloudFunctionsRepositoryProvider);
  return CartService(
    authRepository: authService,
    cartRepository: cartRepository,
    localCartRepository: localCartRepository,
    cloudFunctions: cloudFunctions,
  );
});

final cartItemsListProvider = StreamProvider.autoDispose<List<Item>>((ref) {
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.asData?.value;
  if (user != null) {
    final cartRepository = ref.watch(cartRepositoryProvider);
    return cartRepository.itemsList(user.uid);
  } else {
    final localCartRepository = ref.watch(localCartRepositoryProvider);
    return localCartRepository.itemsList();
  }
});

final cartTotalProvider = StreamProvider.autoDispose<double>((ref) {
  final userValue = ref.watch(authStateChangesProvider);
  final user = userValue.asData?.value;
  if (user != null) {
    final cartRepository = ref.watch(cartRepositoryProvider);
    final productsRepository = ref.watch(productsRepositoryProvider);
    return cartTotalStream(
      productsRepository: productsRepository,
      cartRepository: cartRepository,
      uid: user.uid,
    );
  } else {
    final productsListValue = ref.watch(productsListProvider);
    final productsList = productsListValue.asData?.value ?? [];
    final localCartRepository = ref.watch(localCartRepositoryProvider);
    return localCartRepository.cartTotal(productsList);
  }
});

Stream<double> cartTotalStream({
  required ProductsRepository productsRepository,
  required CartRepository cartRepository,
  required String uid,
}) {
  return Rx.combineLatest2(
      productsRepository.productsList(), cartRepository.itemsList(uid),
      (List<Product> products, List<Item> items) {
    if (items.isNotEmpty) {
      final itemPrices = items.map((item) {
        final product =
            products.firstWhere((product) => product.id == item.productId);
        return product.price * item.quantity;
      }).toList();

      return itemPrices.reduce((value, itemPrice) {
        return value + itemPrice;
      });
    } else {
      return 0.0;
    }
  });
}
