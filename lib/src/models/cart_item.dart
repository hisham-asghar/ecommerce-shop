import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

class CartItem {
  CartItem({required this.productId, required this.quantity})
      : assert(quantity > 0);
  final String productId;
  final int quantity;

  @override
  int get hashCode => productId.hashCode;

  @override
  bool operator ==(covariant CartItem other) {
    return other.productId == productId;
  }

  @override
  String toString() {
    final product = findProduct(productId);
    return 'CartItem(product: $product, quantity: $quantity)';
  }
}
