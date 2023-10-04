import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/card_payment_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment_complete/payment_complete.dart';
import 'package:my_shop_ecommerce_flutter/src/features/not_found/not_found_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/orders_list_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_list/product_list.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/product_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

class NotFoundPage extends Page {
  const NotFoundPage();

  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => const NotFoundScreen(),
      );
}

class ProductListPage extends Page {
  const ProductListPage();

  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => const ProductListScreen(),
      );
}

class ProductDetailsPage extends Page {
  ProductDetailsPage({required this.product})
      : super(key: ValueKey(product.id));
  final Product product;

  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => ProductScreen(product: product),
      );
}

class ShoppingCartPage extends Page {
  const ShoppingCartPage();

  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => const ShoppingCartScreen(),
        fullscreenDialog: true,
      );
}

class CheckoutPage extends Page {
  const CheckoutPage();
  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => const CheckoutScreen(),
        fullscreenDialog: true,
      );
}

class CardPaymentPage extends Page {
  const CardPaymentPage();
  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => const CardPaymentScreen(),
        fullscreenDialog: true,
      );
}

class PaymentCompletePage extends Page {
  const PaymentCompletePage({required this.order});
  final Order order;
  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => PaymentCompleteScreen(order: order),
        fullscreenDialog: true,
      );
}

class OrdersListPage extends Page {
  const OrdersListPage();
  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => const OrdersListScreen(),
        fullscreenDialog: true,
      );
}
