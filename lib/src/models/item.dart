/// A product along with a quantity that can be added to an order/cart
class Item {
  Item({required this.productId, required this.quantity})
      : assert(quantity > 0);
  final String productId;
  final int quantity;

  @override
  int get hashCode => productId.hashCode;

  @override
  bool operator ==(covariant Item other) {
    return other.productId == productId;
  }

  @override
  String toString() {
    return 'Item(productId: $productId, quantity: $quantity)';
  }
}
