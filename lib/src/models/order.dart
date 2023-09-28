import 'package:my_shop_ecommerce_flutter/src/models/items_list.dart';

enum PaymentStatus { notPaid, paid }

enum DeliveryStatus { notDelivered, delivered }

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
}
