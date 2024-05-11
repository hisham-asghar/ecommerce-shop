import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/presentation/admin/admin_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/cart/presentation/shopping_cart/shopping_cart_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/presentation/card_payment_screen/card_payment_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/presentation/checkout_screen/checkout_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/presentation/admin/admin_orders_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/data/auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/presentation/account/account_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/presentation/orders_list/orders_list_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/presentation/admin/admin_product_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/presentation/admin/admin_products_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/presentation/product_screen/product_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/presentation/products_list/products_list_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/reviews/presentation/leave_review_page/leave_review_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/not_found/not_found_screen.dart';

enum AppRoute {
  home,
  product,
  leaveReview,
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
  cardPayment,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    redirect: (state) {
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        // on login complete, redirect to home
        if (state.location == '/signIn') {
          return '/';
        }
      } else {
        // on logout complete, redirect to home
        if (state.location == '/account') {
          return '/';
        }
        // TODO: Only allow admin pages if user is admin (#125)
        if (state.location.startsWith('/admin') ||
            state.location.startsWith('/orders')) {
          return '/';
        }
      }
      // disallow card payment screen if not on web
      if (!kIsWeb) {
        if (state.location == '/cart/checkout/card') {
          return '/cart/checkout';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ProductsListScreen(),
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
              routes: [
                GoRoute(
                  path: 'review',
                  name: AppRoute.leaveReview.name,
                  pageBuilder: (context, state) {
                    final productId = state.params['id']!;
                    return MaterialPage(
                      key: state.pageKey,
                      fullscreenDialog: true,
                      child: LeaveReviewScreen(productId: productId),
                    );
                  },
                ),
              ]),
          GoRoute(
            path: 'signIn',
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
            path: 'cart',
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
                  key: ValueKey(state.location),
                  fullscreenDialog: true,
                  child: const CheckoutScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'card',
                    name: AppRoute.cardPayment.name,
                    pageBuilder: (context, state) => MaterialPage(
                      key: state.pageKey,
                      fullscreenDialog: true,
                      child: const CardPaymentScreen(),
                    ),
                  ),
                ],
              ),
            ],
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
                ],
              ),
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
    ],
    errorPageBuilder: (_, state) => MaterialPage(
      key: state.pageKey,
      child: const NotFoundScreen(),
    ),
  );
});
