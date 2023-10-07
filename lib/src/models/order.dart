import 'package:my_shop_ecommerce_flutter/src/models/item.dart';

enum PaymentStatus { notPaid, paid }

extension PaymentStatusString on PaymentStatus {
  String status() {
    switch (this) {
      case PaymentStatus.notPaid:
        return 'Not Paid';
      case PaymentStatus.paid:
        return 'Completed';
    }
  }
}

enum OrderStatus { confirmed, shipped, delivered }

extension OrderStatusString on OrderStatus {
  String status() {
    switch (this) {
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }
}

class Order {
  Order({
    required this.id,
    required this.userId,
    required this.items,
    // required this.paymentStatus,
    required this.orderStatus,
    required this.orderDate,
    this.deliveryDate,
  });

  /// Order ID generated on payment
  final String id;

  /// ID of the user who made the order
  final String userId;

  /// List of items in that order
  final List<Item> items;
  // final PaymentStatus paymentStatus;
  final OrderStatus orderStatus;
  final DateTime orderDate;
  final DateTime? deliveryDate;

  Order copyWith({
    String? id,
    String? userId,
    List<Item>? items,
    OrderStatus? orderStatus,
    DateTime? orderDate,
    DateTime? deliveryDate,
  }) =>
      Order(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        items: items ?? this.items,
        orderStatus: orderStatus ?? this.orderStatus,
        orderDate: orderDate ?? this.orderDate,
        deliveryDate: deliveryDate ?? this.deliveryDate,
      );

  @override
  int get hashCode => id.hashCode & userId.hashCode;

  @override
  bool operator ==(covariant Order other) {
    return id == other.id && userId == other.userId;
  }

  @override
  String toString() {
    return 'Order(id: $id, orderDate: $orderDate, items: $items)';
  }
}
