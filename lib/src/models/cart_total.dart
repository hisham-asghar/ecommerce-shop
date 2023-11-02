class CartTotal {
  final double total;
  CartTotal({
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'total': total,
    };
  }

  factory CartTotal.fromMap(Map<String, dynamic> map) {
    return CartTotal(
      total: (map['total'] as num).toDouble(),
    );
  }

  @override
  String toString() => 'CartTotal(total: $total)';
}
