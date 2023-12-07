import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/features/account/account_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/admin/admin_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/admin/orders/admin_orders_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/admin/products/admin_product_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/admin/products/admin_products_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/checkout_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/payment_complete/payment_complete.dart';
import 'package:my_shop_ecommerce_flutter/src/features/not_found/not_found_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/orders_list_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_list/product_list.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/product_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/shopping_cart/shopping_cart.dart';
import 'package:my_shop_ecommerce_flutter/src/features/sign_in/email_password_sign_in_model.dart';
import 'package:my_shop_ecommerce_flutter/src/features/sign_in/email_password_sign_in_screen.dart';

enum AppRoute {
  home,
  product,
  paymentComplete,
  orders,
  account,
  admin,
  adminProducts,
  adminProduct,
  adminOrders,
  signIn,
  cart,
  checkout,
  pay,
}

extension AppRouteName on AppRoute {
  String get name => describeEnum(this);
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ProductListScreen(),
        ),
        routes: [
          GoRoute(
            path: 'product/:id',
            name: AppRoute.product.name,
            pageBuilder: (context, state) {
              final productId = state.params['id']!;
              return MaterialPage(
                key: state.pageKey,
                child: ProductScreen(productId: productId),
              );
            },
          ),
          GoRoute(
            path: 'paymentComplete/:id',
            name: AppRoute.paymentComplete.name,
            pageBuilder: (context, state) {
              final orderId = state.params['id']!;
              return MaterialPage(
                key: state.pageKey,
                fullscreenDialog: true,
                child: PaymentCompleteScreen(orderId: orderId),
              );
            },
          ),
          GoRoute(
            path: 'orders',
            name: AppRoute.orders.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const OrdersListScreen(),
            ),
          ),
          GoRoute(
            path: 'account',
            name: AppRoute.account.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const AccountScreen(),
            ),
          ),
          GoRoute(
            path: 'admin',
            name: AppRoute.admin.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const AdminScreen(),
            ),
            routes: [
              GoRoute(
                  path: 'products',
                  name: AppRoute.adminProducts.name,
                  pageBuilder: (context, state) => MaterialPage(
                        key: state.pageKey,
                        fullscreenDialog: true,
                        child: const AdminProductsScreen(),
                      ),
                  routes: [
                    GoRoute(
                      path: ':id',
                      name: AppRoute.adminProduct.name,
                      pageBuilder: (context, state) {
                        final productId = state.params['id']!;
                        return MaterialPage(
                          key: state.pageKey,
                          fullscreenDialog: true,
                          child: AdminProductScreen(
                              productId: productId == 'new' ? null : productId),
                        );
                      },
                    ),
                  ]),
              GoRoute(
                path: 'orders',
                name: AppRoute.adminOrders.name,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: const AdminOrdersScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const EmailPasswordSignInScreen(
            formType: EmailPasswordSignInFormType.signIn,
          ),
        ),
      ),
      GoRoute(
        path: '/cart',
        name: AppRoute.cart.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const ShoppingCartScreen(),
        ),
        routes: [
          // checkout
          GoRoute(
            path: 'checkout',
            name: AppRoute.checkout.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const CheckoutScreen(),
            ),
          ),
        ],
      ),
    ],
    // TODO: use error?
    errorPageBuilder: (_, state) => MaterialPage<void>(
      key: state.pageKey,
      child: const NotFoundScreen(),
    ),
  );
});
