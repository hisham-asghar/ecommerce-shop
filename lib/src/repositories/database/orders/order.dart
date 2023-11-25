import 'package:flutter/foundation.dart';

import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';

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
  String get rawString => describeEnum(this);

  static OrderStatus fromString(String string) {
    if (string == 'confirmed') return OrderStatus.confirmed;
    if (string == 'shipped') return OrderStatus.shipped;
    if (string == 'delivered') return OrderStatus.delivered;
    throw UnsupportedError('Could not parse order status: $string');
  }

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
    required this.total,
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
  final double total;

  Order copyWith({
    String? id,
    String? userId,
    List<Item>? items,
    OrderStatus? orderStatus,
    DateTime? orderDate,
    //DateTime? deliveryDate,
    double? total,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      orderStatus: orderStatus ?? this.orderStatus,
      orderDate: orderDate ?? this.orderDate,
      //deliveryDate: deliveryDate ?? this.deliveryDate,
      total: total ?? this.total,
    );
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        items.hashCode ^
        orderStatus.hashCode ^
        orderDate.hashCode ^
        total.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        other.id == id &&
        other.userId == userId &&
        listEquals(other.items, items) &&
        other.orderStatus == orderStatus &&
        other.orderDate == orderDate &&
        other.total == total;
  }

  @override
  String toString() {
    return 'Order(id: $id, userId: $userId, items: $items, orderStatus: $orderStatus, orderDate: $orderDate, total: $total)';
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((x) => x.toMap()).toList(),
      'orderStatus': orderStatus.rawString,
      'orderDate': orderDate.toIso8601String(),
      'total': total,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    return Order(
      id: id,
      userId: map['userId'],
      items: List<Item>.from(map['items']?.map(
        (x) =>
            Item.fromMap(Map<String, dynamic>.from(x as Map<Object?, Object?>)),
      )),
      orderStatus: OrderStatusString.fromString(map['orderStatus']),
      orderDate: DateTime.parse(map['orderDate']),
      total: (map['total'] as num).toDouble(),
    );
  }
}
