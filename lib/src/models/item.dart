/// A product along with a quantity that can be added to an order/cart
class Item {
  Item({
    required this.productId,
    required this.quantity,
  });
  final String productId;
  final int quantity;

  @override
  int get hashCode => productId.hashCode ^ quantity.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item &&
        other.productId == productId &&
        other.quantity == quantity;
  }

  @override
  String toString() => 'Item(productId: $productId, quantity: $quantity)';

  Item copyWith({
    String? productId,
    int? quantity,
  }) {
    return Item(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      productId: map['productId'],
      quantity: (map['quantity'] as num).toInt(),
    );
  }
}
