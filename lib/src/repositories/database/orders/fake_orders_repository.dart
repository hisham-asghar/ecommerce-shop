import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/remote/fake_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/fake_reviews_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/purchase.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/fake_products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/in_memory_store.dart';
import 'package:uuid/uuid.dart';

class FakeOrdersRepository implements OrdersRepository {
  FakeOrdersRepository({
    required this.productsRepository,
    required this.cartRepository,
    required this.reviewsRepository,
    this.addDelay = true,
  });
  final FakeProductsRepository productsRepository;
  final FakeCartRepository cartRepository;
  final FakeReviewsRepository reviewsRepository;
  final bool addDelay;

  final _orders = InMemoryStore<Map<String, List<Order>>>({});

  @override
  Stream<List<Order>> watchUserOrders(String uid) {
    return _orders.stream.map((ordersData) {
      final ordersList = ordersData[uid] ?? [];
      ordersList.sort(
        (lhs, rhs) => rhs.orderDate.compareTo(lhs.orderDate),
      );
      return ordersList;
    });
  }

  // Not overridden, only available from FakeCloudFunctions
  Future<Order> placeOrder(String uid) async {
    // TODO: This should pull all the data from the shopping cart
    await delay(addDelay);
    final cart = await cartRepository.fetchCart(uid);
    // First, make sure all items are available
    for (var entry in cart.items.entries) {
      final product = productsRepository.getProduct(entry.key);
      if (product.availableQuantity < entry.value) {
        throw AssertionError(
            'Can\'t purchase ${entry.value} quantity of $product');
      }
    }
    // then, place the order
    final value = _orders.value;
    final userOrders = value[uid] ?? [];
    final total = _totalPrice(cart);
    final orderDate = DateTime.now();
    final orderId = const Uuid().v1();
    final order = Order(
      id: orderId,
      userId: uid,
      items: cart.items,
      // TODO: Update with real payment status
      // paymentStatus: PaymentStatus.paid,
      orderStatus: OrderStatus.confirmed,
      orderDate: orderDate,
      total: total,
    );
    userOrders.add(order);
    value[uid] = userOrders;
    _orders.value = value;
    // and update all the product quantities
    for (var entry in cart.items.entries) {
      final product = productsRepository.getProduct(entry.key);
      final updated = product.copyWith(
          availableQuantity: product.availableQuantity - entry.value);
      await productsRepository.updateProduct(updated);
      // Update reviews repository with purchase order data
      await reviewsRepository.addPurchase(
        productId: entry.key,
        uid: uid,
        purchase: Purchase(orderId: orderId, orderDate: orderDate),
      );
    }
    await cartRepository.setCart(uid, const Cart());
    return order;
  }

  @override
  Future<void> updateOrderStatus(Order order) async {
    await delay(addDelay);
    final value = _orders.value;
    final userOrders = value[order.userId] ?? [];
    // TODO: Do this at the call site?
    final index = userOrders.indexWhere((element) => element.id == order.id);
    if (index >= 0) {
      userOrders[index] = order;
      value[order.userId] = userOrders;
      // Note: Adding this to the stream causes additional rebuilds in the OrderList
      _orders.value = value;
    } else {
      throw AssertionError('Order with id ${order.id} does not exist');
    }
  }

  @override
  Stream<List<Order>> watchAllOrders() {
    return _orders.stream.map((ordersData) {
      final orders = <Order>[];
      for (var userOrders in ordersData.values) {
        orders.addAll(userOrders);
      }
      orders.sort(
        (lhs, rhs) => rhs.orderDate.compareTo(lhs.orderDate),
      );
      return orders;
    });
  }

  // Helper method
  double _totalPrice(Cart cart) {
    if (cart.items.isEmpty) {
      return 0.0;
    }

    return cart.items.entries
        // first extract quantity * price for each item
        .map((entry) =>
            entry.value * // quantity
            productsRepository.getProduct(entry.key).price) // price
        // then add them up
        .reduce((value, element) => value + element);
  }
}
