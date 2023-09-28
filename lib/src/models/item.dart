import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

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
    final product = findProduct(productId);
    return 'Item(product: $product, quantity: $quantity)';
  }
}
