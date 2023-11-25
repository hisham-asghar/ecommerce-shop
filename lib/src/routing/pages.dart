import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/features/account/account_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/admin/admin_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/admin/orders/admin_orders_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/admin/products/admin_product_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/admin/products/admin_products_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment/card_payment_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment_complete/payment_complete.dart';
import 'package:my_shop_ecommerce_flutter/src/features/not_found/not_found_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/orders_list_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_list/product_list.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/product_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart.dart';
import 'package:my_shop_ecommerce_flutter/src/features/sign_in/email_password_sign_in_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/order.dart';

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
  ProductDetailsPage({required this.productId})
      : super(key: ValueKey('user-$productId'));
  final String productId;

  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => ProductScreen(productId: productId),
      );
}

class EmailPasswordSignInPage extends Page {
  const EmailPasswordSignInPage();

  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => const EmailPasswordSignInScreen(),
        fullscreenDialog: true,
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

class AccountPage extends Page {
  const AccountPage();
  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => const AccountScreen(),
        fullscreenDialog: true,
      );
}

class AdminPage extends Page {
  const AdminPage();
  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => const AdminScreen(),
        fullscreenDialog: true,
      );
}

class AdminOrdersPage extends Page {
  const AdminOrdersPage();
  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => const AdminOrdersScreen(),
        fullscreenDialog: false,
      );
}

class AdminProductsPage extends Page {
  const AdminProductsPage();
  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => const AdminProductsScreen(),
        fullscreenDialog: false,
      );
}

class AdminProductDetailsPage extends Page {
  AdminProductDetailsPage({this.productId})
      : super(
            key: ValueKey(
          productId != null ? 'admin-$productId' : 'admin-new-product',
        ));
  final String? productId;

  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (_) => AdminProductScreen(productId: productId),
      );
}
