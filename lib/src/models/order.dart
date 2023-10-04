import 'package:my_shop_ecommerce_flutter/src/models/items_list.dart';

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
    required this.itemsList,
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
  final ItemsList itemsList;
  // final PaymentStatus paymentStatus;
  final OrderStatus orderStatus;
  final DateTime orderDate;
  final DateTime? deliveryDate;

  @override
  int get hashCode => id.hashCode & userId.hashCode;

  @override
  bool operator ==(covariant Order other) {
    return id == other.id && userId == other.userId;
  }

  @override
  String toString() {
    return 'Order(id: $id, orderDate: $orderDate, itemsList: $itemsList)';
  }
}
