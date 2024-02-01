/// Model class containing order details that need to be shown in the product
/// page if the product was purchased by the current user.
class Purchase {
  const Purchase({
    required this.orderId,
    required this.orderDate,
  });
  final String orderId;
  final DateTime orderDate;

  Purchase copyWith({
    String? orderId,
    DateTime? orderDate,
  }) {
    return Purchase(
      orderId: orderId ?? this.orderId,
      orderDate: orderDate ?? this.orderDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'orderDate': orderDate.toIso8601String(),
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      orderId: map['orderId'] ?? '',
      orderDate: DateTime.parse(map['orderDate']),
    );
  }

  @override
  String toString() => 'Purchase(orderId: $orderId, orderDate: $orderDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Purchase &&
        other.orderId == orderId &&
        other.orderDate == orderDate;
  }

  @override
  int get hashCode => orderId.hashCode ^ orderDate.hashCode;
}
