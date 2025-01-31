import 'package:flutter/foundation.dart';
import 'package:my_shop_ecommerce_flutter/src/exceptions/app_exception.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/domain/item.dart';

enum OrderStatus { confirmed, shipped, delivered }

extension OrderStatusString on OrderStatus {
  static OrderStatus fromString(String string) {
    if (string == 'confirmed') return OrderStatus.confirmed;
    if (string == 'shipped') return OrderStatus.shipped;
    if (string == 'delivered') return OrderStatus.delivered;
    throw AppException.parseError('Could not parse order status: $string');
  }
}

/// * The order identifier is an important concept and can have its own type.
typedef OrderID = String;

/// Model class representing an order placed by the user.
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
  final OrderID id;

  /// ID of the user who made the order
  final String userId;

  /// List of items in that order
  final Map<String, int> items;
  // final PaymentStatus paymentStatus;
  final OrderStatus orderStatus;
  final DateTime orderDate;
  final double total;

  Order copyWith({
    String? id,
    String? userId,
    Map<String, int>? items,
    OrderStatus? orderStatus,
    DateTime? orderDate,
    double? total,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      orderStatus: orderStatus ?? this.orderStatus,
      orderDate: orderDate ?? this.orderDate,
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
        mapEquals(other.items, items) &&
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
      'items': items,
      'orderStatus': orderStatus.name,
      'orderDate': orderDate.toIso8601String(),
      'total': total,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    return Order(
      id: id,
      userId: map['userId'],
      items: _parseItems(map['items']),
      orderStatus: OrderStatusString.fromString(map['orderStatus']),
      orderDate: DateTime.parse(map['orderDate']),
      total: (map['total'] as num).toDouble(),
    );
  }

  // Helper method for backwards compatibility
  // TODO: Simplify once data has been migrated
  static Map<String, int> _parseItems(dynamic value) {
    if (value is List<dynamic>) {
      final items = List<Item>.from(value.map((x) => Item.fromMap(x)));
      return Map<String, int>.fromEntries(
          items.map((item) => MapEntry(item.productId, item.quantity)));
    } else if (value is Map<String, dynamic>) {
      return Map<String, int>.from(value);
    } else {
      throw AppException.parseError('Invalid items: $value');
    }
  }
}
