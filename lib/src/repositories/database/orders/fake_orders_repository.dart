import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/fake_cart_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/fake_reviews_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/purchase.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/delay.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/products/fake_products_repository.dart';
import 'package:rxdart/rxdart.dart';
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

  Map<String, List<Order>> ordersData = {};
  final _ordersDataSubject =
      BehaviorSubject<Map<String, List<Order>>>.seeded({});
  Stream<Map<String, List<Order>>> get _ordersDataStream =>
      _ordersDataSubject.stream;

  @override
  Stream<List<Order>> watchUserOrders(String uid) {
    return _ordersDataStream.map((ordersData) {
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
    final items = await cartRepository.fetchItemsList(uid);
    // First, make sure all items are available
    for (var item in items) {
      final product = productsRepository.getProduct(item.productId);
      if (product.availableQuantity < item.quantity) {
        throw AssertionError(
            'Can\'t purchase ${item.quantity} quantity of $product');
      }
    }
    // then, place the order
    final userOrders = ordersData[uid] ?? [];
    final total = cartRepository.totalPrice(items);
    final orderDate = DateTime.now();
    final orderId = const Uuid().v1();
    final order = Order(
      id: orderId,
      userId: uid,
      items: items,
      // TODO: Update with real payment status
      // paymentStatus: PaymentStatus.paid,
      orderStatus: OrderStatus.confirmed,
      orderDate: orderDate,
      total: total,
    );
    userOrders.add(order);
    ordersData[uid] = userOrders;
    _ordersDataSubject.add(ordersData);
    // and update all the product quantities
    for (var item in items) {
      final product = productsRepository.getProduct(item.productId);
      final updated = product.copyWith(
          availableQuantity: product.availableQuantity - item.quantity);
      await productsRepository.updateProduct(updated);
      // Update reviews repository with purchase order data
      await reviewsRepository.addPurchase(
        productId: item.productId,
        uid: uid,
        purchase: Purchase(orderId: orderId, orderDate: orderDate),
      );
    }
    await cartRepository.removeAllItems(uid);
    return order;
  }

  @override
  Future<void> updateOrderStatus(Order order) async {
    await delay(addDelay);
    final userOrders = ordersData[order.userId] ?? [];
    // TODO: Do this at the call site?
    final index = userOrders.indexWhere((element) => element.id == order.id);
    if (index >= 0) {
      userOrders[index] = order;
      ordersData[order.userId] = userOrders;
      // Note: Adding this to the stream causes additional rebuilds in the OrderList
      _ordersDataSubject.add(ordersData);
    } else {
      throw AssertionError('Order with id ${order.id} does not exist');
    }
  }

  @override
  Stream<List<Order>> watchAllOrders() {
    return _ordersDataStream.map((ordersData) {
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
}
