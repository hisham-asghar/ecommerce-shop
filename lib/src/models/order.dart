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

enum DeliveryStatus { notDelivered, delivered }

extension DeliveryStatusString on DeliveryStatus {
  String status() {
    switch (this) {
      case DeliveryStatus.notDelivered:
        return 'Not Delivered';
      case DeliveryStatus.delivered:
        return 'Delivered';
    }
  }
}

class Order {
  Order({
    required this.id,
    required this.userId,
    required this.itemsList,
    required this.paymentStatus,
    required this.deliveryStatus,
  });

  /// Order ID generated on payment
  final String id;

  /// ID of the user who made the order
  final String userId;

  /// List of items in that order
  final ItemsList itemsList;
  final PaymentStatus paymentStatus;
  final DeliveryStatus deliveryStatus;

  @override
  int get hashCode => id.hashCode & userId.hashCode;

  @override
  bool operator ==(covariant Order other) {
    return id == other.id && userId == other.userId;
  }

  @override
  String toString() {
    return 'Order(id: $id)';
  }
}
